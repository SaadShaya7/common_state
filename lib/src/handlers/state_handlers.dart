import 'package:common_state/src/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';
import '../models/pagination_model.dart';
import '../types.dart';

class StateHandlers {
  /// Manage the state according to the value returned from callback
  static Future<void> handelApiResult<T, E>({
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

  static Future<void> handelMultiApiResult<T, E>({
    required FutureResult<T, E> Function() callback,
    required Emitter<Map<int, CommonState<T, E>>> emit,
    required Map<int, CommonState<T, E>> state,
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
    required Emitter<Map<int, CommonState<T, E>>> emit,
    required Map<int, CommonState<T, E>> state,
    required int index,
  }) async {
    final d = state[index];
    if (d is PaginationClass) {
      final d = state[index] as PaginationClass<T, E>;
      final controller = d.pagingController;

      if (data != null) {
        final isLastPage = StateHandlers.isLastPage(data);
        if (isLastPage) {
          controller.appendLastPage(data.data);
        } else {
          controller.appendPage(data.data, pageKey + 1);
        }
      } else {
        final newItems = await getData?.call();
        newItems?.fold(
          (left) => controller.error = left,
          (right) {
            final isLastPage = StateHandlers.isLastPage(right);
            if (isLastPage) {
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
