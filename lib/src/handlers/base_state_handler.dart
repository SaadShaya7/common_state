import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../common_state.dart';

class BaseHandler {
  //=============================================== Normal states ===============================================
  static Future<void> apiCall<T, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required dynamic emit,
    Function(T)? onSuccess,
    Function(E)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
    Future<void> Function()? preCall,
  }) async {
    await preCall?.call();

    emit(LoadingState<T, E>());

    final result = await apiCall();

    result.fold(
      (l) {
        emit(FailureState<T, E>(l));
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
    required CommonStateFutureResult<T, E> Function() apiCall,
    required dynamic emit,
    required StateObject state,
    required String stateName,
    Future<void> Function()? preCall,
    Function(T)? onSuccess,
    Function(E)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
  }) async {
    await preCall?.call();

    emit(state.updateState(stateName, LoadingState<T, E>()));

    final result = await apiCall();

    result.fold(
      (l) {
        emit(state.updateState(stateName, FailureState<T, E>(l)));
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

  static Future<void> paginatedApiCall<T extends BasePagination, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required int pageKey,
    required dynamic emit,
    required CommonState<T, E> state,
    void Function(T data)? onFirstPageFetched,
    Future<void> Function()? preCall,
  }) async {
    if (state is! PaginationState) throw Exception('State is not a PaginationState');

    final controller = state.pagingController;

    await preCall?.call();

    final result = await apiCall();

    result.fold(
      (left) => controller.error = left,
      (right) => _handelPaginationController(
        right,
        controller,
        pageKey,
        onFirstPageFetched: onFirstPageFetched,
      ),
    );
  }

  static Future<void> multiStatePaginatedApiCall<T extends BasePagination, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required int pageKey,
    required dynamic emit,
    required StateObject state,
    required String stateName,
    void Function(T data)? onFirstPageFetched,
    Future<void> Function()? preCall,
  }) async {
    if (state.getState(stateName) is! PaginationState) throw Exception('$stateName is not a PaginationState');

    final PaginationState paginationState = state.getState(stateName) as PaginationState;

    final PagingController<int, dynamic> controller = paginationState.pagingController;

    await preCall?.call();

    final result = await apiCall();

    result.fold(
      (left) => controller.error = left,
      (right) => _handelPaginationController<T>(
        right,
        controller,
        pageKey,
        onFirstPageFetched: onFirstPageFetched,
      ),
    );
  }

  //=============================================== Helpers ===============================================

  static void _handelPaginationController<T>(T data, PagingController controller, int pageKey,
      {void Function(T data)? onFirstPageFetched}) {
    final PaginationModel paginationData =
        data is PaginatedData ? (data).paginatedData : data as PaginationModel;

    if (pageKey == controller.firstPageKey) onFirstPageFetched?.call(data);

    if (_isLastPage(paginationData)) {
      controller.appendLastPage(paginationData.data);
      return;
    }
    controller.appendPage(paginationData.data, pageKey + 1);
  }

  static bool _isResponseEmpty<T>(bool Function(T)? emptyChecker, T response) =>
      (response is List && response.isEmpty) || (emptyChecker != null && emptyChecker(response));

  static bool _isLastPage(PaginationModel right) => ((right.totalPages) - 1) <= (right.pageNumber);
}
