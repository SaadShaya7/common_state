import 'package:common_state/src/extensions.dart';

import '../../common_state.dart';
import '../models/pagination_model.dart';

class CubitStateHandlers {
  static bool isResponseEmpty<T>(bool Function(T)? emptyChecker, T response) =>
      (response is List && response.isEmpty) || (emptyChecker != null && emptyChecker(response));

  static bool isLastPage(PaginationModel right) => ((right.totalPages) - 1) == (right.pageNumber);

  static bool hasReachedMax({required int totalPage, required int pageNumber}) =>
      totalPage == 0 ? totalPage == pageNumber : totalPage == pageNumber + 1;

  static Future<void> handelApiCall<T, E>({
    bool Function(T)? emptyChecker,
    required FutureResult<T, E> Function() callback,
    required void Function(CommonState<T, E>) emit,
  }) async {
    emit(const LoadingState());

    final result = await callback();

    result.fold(
      (l) => emit(ErrorState(l)),
      (r) {
        if (isResponseEmpty(emptyChecker, r)) {
          emit(const EmptyState());
          return;
        }
        emit(SuccessState(r));
      },
    );
  }

  static Future<void> multiStateApiCall<T, E>({
    required FutureResult<T, E> Function() callback,
    required Function(States<E>) emit,
    required States<E> state,
    required int index,
    Function(T)? onSuccess,
    bool Function(T)? emptyChecker,
  }) async {
    emit(state.setState(index, LoadingState<T, E>()));
    final result = await callback();
    result.fold(
      (l) => emit(state.setState(index, ErrorState<T, E>(l))),
      (r) {
        if (isResponseEmpty(emptyChecker, r)) {
          emit(state.setState(index, EmptyState<T, E>()));
          return;
        }
        emit(state.setState(index, SuccessState<T, E>(r)));
        if (onSuccess != null) {
          onSuccess(r);
        }
      },
    );
  }

  static Future<void> handlePagination<T, E>({
    FutureResult<PaginationModel<T>, E> Function()? getData,
    PaginationModel<T>? data,
    required int pageKey,
    required Function(CommonState<T, E>) emit,
    required PaginationClass state,
  }) async {
    final controller = state.pagingController;

    if (data != null) {
      final lastPage = isLastPage(data);
      if (lastPage) {
        controller.appendLastPage(data.data);
      } else {
        controller.appendPage(data.data, pageKey + 1);
      }
    } else {
      final newItems = await getData?.call();
      newItems?.fold(
        (left) => controller.error = left,
        (right) {
          final lastPage = isLastPage(right);
          if (lastPage) {
            controller.appendLastPage(right.data);
          } else {
            controller.appendPage(right.data, pageKey + 1);
          }
        },
      );
    }
  }
}
