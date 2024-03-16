import 'package:common_state/src/handlers/base_state_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';

/// Used to handle bloc state changes.
class BlocStateHandlers {
  static Future<void> multiStateApiCall<T, E>({
    required CommonStateFutureResult<T, E> Function() apiCall,
    required Emitter<StateObject> emit,
    required StateObject state,
    required String stateName,
    void Function(T data)? onSuccess,
    void Function(E failure)? onFailure,
    bool Function(T)? emptyChecker,
    Future<void> Function()? preCall,
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
    Future<void> Function()? preCall,
  }) =>
      BaseHandler.multiStatePaginatedApiCall<T, E>(
        preCall: preCall,
        pageKey: pageKey,
        emit: emit,
        state: state,
        stateName: stateName,
        apiCall: apiCall,
        onFirstPageFetched: onFirstPageFetched,
      );
}
