import 'package:common_state/src/handlers/base_state_handler.dart';

import '../../common_state.dart';

///
class CubitStateHandlers {
  static Future<void> apiCall<T, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required void Function(CommonState<T, E>) emit,

    /// Optional callback to trigger in case of success
    Function(T)? onSuccess,

    /// Optional callback to trigger in case of Failure
    Function(E)? onFailure,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,

    /// Message to pass to empty state
    String? emptyMessage,
    Future<void> Function()? preCall,
  }) =>
      BaseHandler.apiCall(
        apiCall: apiCall,
        emit: emit,
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
        onSuccess: onSuccess,
        onFailure: onFailure,
        preCall: preCall,
      );

  static Future<void> multiStateApiCall<T, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required dynamic emit,
    required StateObject state,
    required String stateName,

    /// Optional callback to trigger in case of success
    Function(T)? onSuccess,

    /// Optional callback to trigger in case of Failure
    Function(E)? onFailure,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,

    /// Message to pass to empty state
    String? emptyMessage,
    Future<void> Function()? preCall,
  }) =>
      BaseHandler.multiStateApiCall<T, E>(
        apiCall: apiCall,
        emit: emit,
        state: state,
        stateName: stateName,
        onSuccess: onSuccess,
        onFailure: onFailure,
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
        preCall: preCall,
      );

  static Future<void> paginatedApiCall<T extends BasePagination, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required int pageKey,
    required Function(CommonState<T, E>) emit,
    required CommonState<T, E> state,
    void Function(T data)? onFirstPageFetched,
    Future<void> Function()? preCall,
  }) =>
      BaseHandler.paginatedApiCall<T, E>(
        pageKey: pageKey,
        emit: emit,
        state: state,
        apiCall: apiCall,
        onFirstPageFetched: onFirstPageFetched,
        preCall: preCall,
      );

  static Future<void> multiStatePaginatedApiCall<T extends BasePagination, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required int pageKey,
    required dynamic emit,
    required StateObject state,
    required String stateName,
    void Function(T data)? onFirstPageFetched,
  }) =>
      BaseHandler.multiStatePaginatedApiCall<T, E>(
        pageKey: pageKey,
        emit: emit,
        state: state,
        stateName: stateName,
        apiCall: apiCall,
        onFirstPageFetched: onFirstPageFetched,
      );
}
