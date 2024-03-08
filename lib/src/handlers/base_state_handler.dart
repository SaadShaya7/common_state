import 'package:common_state/src/models/paginated_data.dart';

import '../../common_state.dart';
import '../models/pagination_model.dart';

class BaseHandler {
  //=============================================== Normal states ===============================================
  static Future<void> apiCall<T, E>({
    required FutureResult<T, E> Function() apiCall,
    required dynamic emit,
    Function(T)? onSuccess,
    Function(E)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
  }) async {
    emit(LoadingState<T, E>());

    final result = await apiCall();

    result.fold(
      (l) {
        emit(ErrorState<T, E>(l));
        onFailure?.call(l);
      },
      (r) {
        if (_isResponseEmpty(emptyChecker, r)) {
          emit(EmptyState<T, E>(emptyMessage));
          return;
        }
        emit(SuccessState<T, E>(r));
        onSuccess?.call(r);
      },
    );
  }

  static Future<void> multiStateApiCall<T, E>({
    required FutureResult<T, E> Function() apiCall,
    required dynamic emit,
    required StateObject state,
    required String stateName,
    Function(T)? onSuccess,
    Function(E)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
  }) async {
    emit(state.updateState(stateName, LoadingState<T, E>()));
    final result = await apiCall();
    result.fold(
      (l) {
        emit(state.updateState(stateName, ErrorState<T, E>(l)));
        onFailure?.call(l);
      },
      (r) {
        if (_isResponseEmpty(emptyChecker, r)) {
          emit(state.updateState(stateName, EmptyState<T, E>(emptyMessage)));
          return;
        }
        emit(state.updateState(stateName, SuccessState<T, E>(r)));
        onSuccess?.call(r);
      },
    );
  }

  //=============================================== Pagination states ===============================================

  static Future<void> paginatedApiCall<T, E>({
    required FutureResult<T, E> Function() apiCall,
    required int pageKey,
    required dynamic emit,
    required CommonState state,
  }) async {
    if (state is! PaginationState) throw Exception('State is not a PaginationState');

    if (T is! PaginationModel && T is! PaginatedData) {
      throw Exception('${T.runtimeType} is not a PaginationModel or PaginatedData');
    }

    final controller = state.pagingController;

    final result = await apiCall();

    result.fold(
      (left) => controller.error = left,
      (right) {
        final PaginationModel paginationData =
            T is PaginatedData ? (right as PaginatedData).paginatedData : right as PaginationModel;

        if (_isLastPage(paginationData)) {
          controller.appendLastPage(paginationData.data);
          return;
        }
        controller.appendPage(paginationData.data, pageKey + 1);
      },
    );
  }

  static Future<void> multiStatePaginatedApiCall<T, E>({
    required FutureResult<T, E> Function() apiCall,
    required int pageKey,
    required dynamic emit,
    required StateObject state,
    required String stateName,
  }) async {
    if (state.getState(stateName) is! PaginationState) throw Exception('$stateName is not a PaginationState');

    final PaginationState paginationState = state.getState(stateName) as PaginationState;
    final Type dataType = paginationState.data.runtimeType;

    if (dataType is! PaginationModel && T is! PaginatedData) {
      throw Exception('$dataType is not a PaginationModel or PaginatedData');
    }

    final controller = paginationState.pagingController;

    final result = await apiCall();
    result.fold(
      (left) => controller.error = left,
      (right) {
        final PaginationModel paginationData =
            T is PaginatedData ? (right as PaginatedData).paginatedData : right as PaginationModel;

        if (_isLastPage(paginationData)) {
          controller.appendLastPage(paginationData.data);
          return;
        }
        controller.appendPage(paginationData.data, pageKey + 1);
      },
    );
  }

  //=============================================== Helpers ===============================================

  static bool _isResponseEmpty<T>(bool Function(T)? emptyChecker, T response) =>
      (response is List && response.isEmpty) || (emptyChecker != null && emptyChecker(response));

  static bool _isLastPage(PaginationModel right) => ((right.totalPages) - 1) == (right.pageNumber);

  static bool _hasReachedMax({required int totalPage, required int pageNumber}) =>
      totalPage == 0 ? totalPage == pageNumber : totalPage == pageNumber + 1;
}
