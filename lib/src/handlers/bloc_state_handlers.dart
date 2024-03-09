import 'package:common_state/src/handlers/base_state_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';

/// Used to handle bloc state changes.
class BlocStateHandlers {
  static Future<void> multiStateApiCall<T, E>({
    required FutureResult<T, E> Function() apiCall,
    required Emitter<StateObject> emit,
    required StateObject state,
    required String stateName,

    /// Optional callback to trigger in case of success
    void Function(T data)? onSuccess,

    /// Optional callback to trigger in case of Failure
    void Function(E failure)? onFailure,

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
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
        onFailure: onFailure,
      );

  static Future<void> multiStatePaginatedApiCall<T, E>({
    required FutureResult<T, E> Function() apiCall,
    required int pageKey,
    required Emitter<StateObject> emit,
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
