import 'package:common_state/src/handlers/base_state_handler.dart';

import '../../common_state.dart';

///
class CubitStateHandlers {
  static Future<void> apiCall<T, E>({
    required FutureResult<T, E> Function() apiCall,
    required void Function(CommonState<T, E>) emit,

    /// Optional callback to trigger in case of success
    Function(T)? onSuccess,

    /// Optional callback to trigger in case of Failure
    Function(E)? onFailure,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,

    /// Message to pass to empty state
    String? emptyMessage,
  }) =>
      BaseHandler.apiCall(
        apiCall: apiCall,
        emit: emit,
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );

  static Future<void> multiStateApiCall<T, E>({
    required FutureResult<T, E> Function() apiCall,
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
      );

  static Future<void> paginatedApiCall<T extends BasePagination, E>({
    required FutureResult<T, E> Function() apiCall,
    required int pageKey,
    required Function(CommonState<T, E>) emit,
    required CommonState<T, E> state,
  }) =>
      BaseHandler.paginatedApiCall<T, E>(
        pageKey: pageKey,
        emit: emit,
        state: state,
        apiCall: apiCall,
      );

  static Future<void> multiStatePaginatedApiCall<T extends BasePagination, E>({
    required FutureResult<PaginationModel<T>, E> Function() apiCall,
    required int pageKey,
    required dynamic emit,
    required StateObject state,
    required String stateName,
  }) =>
      BaseHandler.multiStatePaginatedApiCall<T, E>(
        pageKey: pageKey,
        emit: emit,
        state: state,
        stateName: stateName,
        apiCall: apiCall,
      );
}
