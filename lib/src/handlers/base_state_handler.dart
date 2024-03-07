import '../../common_state.dart';
import '../models/pagination_model.dart';

class BaseHandler {
  static Future<void> apiCall<T, E>({
    required FutureResult<T, E> Function() callback,
    required dynamic emit,
    bool Function(T)? emptyChecker,
  }) async {
    emit(LoadingState<T, E>());

    final result = await callback();

    result.fold(
      (l) => emit(ErrorState<T, E>(l)),
      (r) {
        if (_isResponseEmpty(emptyChecker, r)) {
          emit(EmptyState<T, E>());
          return;
        }
        emit(SuccessState<T, E>(r));
      },
    );
  }

  static Future<void> multiStateApiCall<T, E>({
    required FutureResult<T, E> Function() callback,
    required dynamic emit,
    required StateObject state,
    required String stateName,
    Function(T)? onSuccess,
    bool Function(T)? emptyChecker,
  }) async {
    emit(state.updateState(stateName, LoadingState<T, E>()));
    final result = await callback();
    result.fold(
      (l) => emit(state.updateState(stateName, ErrorState<T, E>(l))),
      (r) {
        if (_isResponseEmpty(emptyChecker, r)) {
          emit(state.updateState(stateName, EmptyState<T, E>()));
          return;
        }
        emit(state.updateState(stateName, SuccessState<T, E>(r)));
        if (onSuccess != null) {
          onSuccess(r);
        }
      },
    );
  }

  static Future<void> paginatedApiCall<T, E>({
    required int pageKey,
    required dynamic emit,
    required CommonState state,
    FutureResult<PaginationModel<T>, E> Function()? getData,
    PaginationModel<T>? data,
  }) async {
    if (state is! PaginationState) throw Exception('State is not a PaginationState');

    final controller = state.pagingController;

    if (data != null) {
      if (_isLastPage(data)) {
        controller.appendLastPage(data.data);
      } else {
        controller.appendPage(data.data, pageKey + 1);
      }
    } else {
      final newItems = await getData?.call();
      newItems?.fold(
        (left) => controller.error = left,
        (right) {
          if (_isLastPage(right)) {
            controller.appendLastPage(right.data);
          } else {
            controller.appendPage(right.data, pageKey + 1);
          }
        },
      );
    }
  }

  static Future<void> multiStatePaginatedApiCall<T, E>({
    required int pageKey,
    required dynamic emit,
    required StateObject state,
    required String stateName,
    FutureResult<PaginationModel<T>, E> Function()? getData,
    PaginationModel<T>? data,
  }) async {
    if (state.getState(stateName) is! PaginationState) throw Exception('$stateName is not a PaginationState');

    final PaginationState<T> paginationClass = state.getState(stateName) as PaginationState<T>;
    final controller = paginationClass.pagingController;

    if (data != null) {
      if (_isLastPage(data)) {
        controller.appendLastPage(data.data);
      } else {
        controller.appendPage(data.data, pageKey + 1);
      }
    } else {
      final newItems = await getData?.call();
      newItems?.fold(
        (left) => controller.error = left,
        (right) {
          if (_isLastPage(right)) {
            controller.appendLastPage(right.data);
          } else {
            controller.appendPage(right.data, pageKey + 1);
          }
        },
      );
    }
  }

  //=============================================== Helpers ===============================================

  static bool _isResponseEmpty<T>(bool Function(T)? emptyChecker, T response) =>
      (response is List && response.isEmpty) || (emptyChecker != null && emptyChecker(response));

  static bool _isLastPage(PaginationModel right) => ((right.totalPages) - 1) == (right.pageNumber);

  static bool _hasReachedMax({required int totalPage, required int pageNumber}) =>
      totalPage == 0 ? totalPage == pageNumber : totalPage == pageNumber + 1;
}
