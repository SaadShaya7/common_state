import 'package:common_state/src/handlers/base_state_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';

/// Used to handle bloc state changes.
class BlocStateHandlers {
  static Future<void> multiStateApiCall<T, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required Emitter<StateObject> emit,
    required StateObject state,
    required String stateName,

    /// Optional callback to trigger in case of success
    void Function(T data)? onSuccess,

    /// Optional callback to trigger in case of Failure
    void Function(E failure)? onFailure,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,
    VoidCallback? preCall,

    /// Message to pass to empty state
    String? emptyMessage,
  }) =>
      BaseHandler.multiStateApiCall<T, E>(
        apiCall: apiCall,
        preCall: preCall,
        emit: emit,
        state: state,
        stateName: stateName,
        onSuccess: onSuccess,
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
        onFailure: onFailure,
      );

  static Future<void> multiStatePaginatedApiCall<T extends BasePagination, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required int pageKey,
    required Emitter<StateObject> emit,
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
