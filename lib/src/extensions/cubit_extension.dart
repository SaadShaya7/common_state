// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:common_state/common_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension MultiStateCubitExtension<State extends StateObject<State>> on Cubit<State> {
  void multiStateApiCall<T, E>(
    String stateName,
    CommonStateFutureResult<T, E> Function() apiCall, {
    Function(dynamic)? onSuccess,
    Function(dynamic)? onFailure,
    bool Function(T)? emptyChecker,
    Future<void> Function()? preCall,
    String? emptyMessage,
  }) =>
      CubitStateHandlers.multiStateApiCall(
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

  void multiStatePaginatedApiCall<T extends BasePagination, E>(
    String stateName,
    CommonStateFutureResult<T, E> Function() apiCall,
    int pageKey, {
    void Function(T data)? onFirstPageFetched,
  }) =>
      CubitStateHandlers.multiStatePaginatedApiCall<T, E>(
        apiCall: apiCall,
        pageKey: pageKey,
        emit: emit,
        state: state,
        stateName: stateName,
        onFirstPageFetched: onFirstPageFetched,
      );
}

extension CommonStateCubitExtension on Cubit<CommonState> {
  void apiCall<T, E>(
    CommonStateFutureResult<T, E> Function() apiCall, {
    Function(dynamic)? onSuccess,
    Function(dynamic)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
    Future<void> Function()? preCall,
  }) =>
      CubitStateHandlers.apiCall<T, E>(
        apiCall: apiCall,
        emit: emit,
        onSuccess: onSuccess,
        onFailure: onFailure,
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
        preCall: preCall,
      );

  void paginatedApiCall<T extends BasePagination, E>(
    CommonStateFutureResult<T, E> Function() apiCall,
    int pageKey, {
    void Function(T data)? onFirstPageFetched,
    Future<void> Function()? preCall,
  }) =>
      CubitStateHandlers.paginatedApiCall<T, E>(
        apiCall: apiCall,
        pageKey: pageKey,
        emit: emit,
        state: state as CommonState<T, E>,
        onFirstPageFetched: onFirstPageFetched,
        preCall: preCall,
      );
}
