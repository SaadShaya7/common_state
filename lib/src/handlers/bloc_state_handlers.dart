import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';
import '../models/pagination_model.dart';

class BlocStateHandlers {
  static Future<void> multiStateApiCall<T, E>({
    required FutureResult<T, E> Function() callback,
    required Emitter<StateObject> emit,
    required StateObject state,
    required String stateName,
    Function(T)? onSuccess,
    bool Function(T)? emptyChecker,
  }) async {
    emit(state.updateState(stateName, const LoadingState())!);
    final result = await callback();
    result.fold(
      (l) => emit(state.updateState(stateName, ErrorState<T, E>(l))!),
      (r) {
        if (isResponseEmpty(emptyChecker, r)) {
          emit(state.updateState(stateName, EmptyState<T, E>())!);
          return;
        }
        emit(state.updateState(stateName, SuccessState(r))!);

        onSuccess?.call(r);
      },
    );
  }

  static Future<void> handlePagination<T, E>({
    FutureResult<PaginationModel<T>, E> Function()? getData,
    PaginationModel<T>? data,
    required int pageKey,
    required Emitter<States<E>> emit,
    required States<E> state,
    required int index,
  }) async {
    final paginationClass = state[index];
    if (paginationClass is PaginationState) {
      final paginationClass = state[index] as PaginationState<T>;
      final controller = paginationClass.pagingController;

      if (data != null) {
        if (isLastPage(data)) {
          controller.appendLastPage(data.data);
        } else {
          controller.appendPage(data.data, pageKey + 1);
        }
      } else {
        final newItems = await getData?.call();
        newItems?.fold(
          (left) => controller.error = left,
          (right) {
            if (isLastPage(right)) {
              controller.appendLastPage(right.data);
            } else {
              controller.appendPage(right.data, pageKey + 1);
            }
          },
        );
      }
    }
  }

  static bool isResponseEmpty<T>(bool Function(T)? emptyChecker, T response) =>
      (response is List && response.isEmpty) || (emptyChecker != null && emptyChecker(response));

  static bool isLastPage(PaginationModel right) => ((right.totalPages) - 1) == (right.pageNumber);

  static bool hasReachedMax({required int totalPage, required int pageNumber}) =>
      totalPage == 0 ? totalPage == pageNumber : totalPage == pageNumber + 1;

  static CommonState? getCommonState<T>(Map<int, CommonState> state, int index) => state[index];
}
