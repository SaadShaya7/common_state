import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../common_state.dart';

class StateHandler {
  //=============================================== Normal states ===============================================
  static Future<void> call<T>({
    required FutureResult<T> Function() call,
    required dynamic emit,
    required BaseState state,
    Future<void> Function()? preCall,
    Future<void> Function(T data)? onSuccess,
    Future<void> Function(dynamic failure)? onFailure,
    bool Function(T data)? emptyChecker,
    String? emptyMessage,
    String? stateName,
  }) async {
    await preCall?.call();

    emit(_updateState(stateName, LoadingState<T>(), state));

    final result = await call();

    result.fold(
      (l) async {
        emit(_updateState(stateName, FailureState<T>(l), state));
        await onFailure?.call(l);
      },
      (r) async {
        if (_isResponseEmpty(emptyChecker, r)) {
          emit(_updateState(stateName, EmptyState<T>(emptyMessage), state));
          return;
        }
        emit(_updateState(stateName, SuccessState<T>(r), state));
        await onSuccess?.call(r);
      },
    );
  }

  //=============================================== Pagination states ===============================================

  static Future<void> paginatedApiCall<T extends BasePagination>({
    required FutureResult<T> Function() apiCall,
    required int pageKey,
    required dynamic emit,
    required BaseState state,
    void Function(T data)? onFirstPageFetched,
    Future<void> Function()? preCall,
    bool Function(T data)? isLastPage,
    String? stateName,
  }) async {
    final controller = _getPagingController(state, stateName);

    await preCall?.call();

    final result = await apiCall();

    result.fold(
      (left) => controller.error = left,
      (right) => _handelPaginationController<T>(
        right,
        controller,
        pageKey,
        onFirstPageFetched: onFirstPageFetched,
        isLastPage: isLastPage,
      ),
    );
  }
  //=============================================== Helpers ===============================================

  static void _handelPaginationController<T>(
    T data,
    PagingController controller,
    int pageKey, {
    void Function(T data)? onFirstPageFetched,
    bool Function(T data)? isLastPage,
  }) {
    final PaginationModel paginationData =
        data is PaginatedData ? (data).paginatedData : data as PaginationModel;

    if (pageKey == controller.firstPageKey) onFirstPageFetched?.call(data);

    if (isLastPage?.call(paginationData as T) ?? _isLastPage(paginationData)) {
      controller.appendLastPage(paginationData.data);
      return;
    }
    controller.appendPage(paginationData.data, pageKey + 1);
  }

  static bool _isResponseEmpty<T>(bool Function(T data)? emptyChecker, T response) =>
      (response is List && response.isEmpty) || (emptyChecker != null && emptyChecker(response));

  static bool _isLastPage(PaginationModel data) {
    if (data.totalPages == null || data.pageNumber == null) return false;
    return ((data.totalPages)! - 1) <= (data.pageNumber!);
  }

  static BaseState _updateState(String? stateName, CommonState newState, BaseState oldState) {
    if (stateName == null) {
      if (oldState is! CommonState) {
        throw ArgumentError('stateName can not be null in case of non CommonState', stateName);
      }
      return newState;
    }

    return (oldState as StateObject).updateState(stateName, newState);
  }

  static PagingController<int, T> _getPagingController<T>(BaseState state, String? stateName) {
    if (state is PaginationState) return state.pagingController as PagingController<int, T>;

    if (stateName == null) {
      throw ArgumentError('in case of non Pagination state stateName can not be null', stateName);
    }

    final selectedState = (state as StateObject).getState(stateName);

    if (selectedState is! PaginationState) throw Exception('$stateName is not a PaginationState');

    return selectedState.pagingController as PagingController<int, T>;
  }
}
