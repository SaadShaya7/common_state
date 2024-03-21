// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:common_state/common_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension MultiStateCubitExtension<State extends StateObject<State>> on Cubit<State> {
  void multiStateApiCall<T>(
    String stateName,
    FutureResult<T> Function() apiCall, {
    Future<void> Function()? preCall,
    Future<void> Function(T data)? onSuccess,
    Future<void> Function(dynamic error)? onFailure,
    bool Function(T)? emptyChecker,
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
    FutureResult<T> Function() apiCall,
    int pageKey, {
    void Function(T data)? onFirstPageFetched,
  }) =>
      CubitStateHandlers.multiStatePaginatedApiCall<T>(
        apiCall: apiCall,
        pageKey: pageKey,
        emit: emit,
        state: state,
        stateName: stateName,
        onFirstPageFetched: onFirstPageFetched,
      );
}

extension CommonStateCubitExtension on Cubit<CommonState> {
  void apiCall<T>(
    FutureResult<T> Function() apiCall, {
    Future<void> Function()? preCall,
    Future<void> Function(T data)? onSuccess,
    Future<void> Function(dynamic error)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
  }) =>
      CubitStateHandlers.apiCall<T>(
        apiCall: apiCall,
        emit: emit,
        onSuccess: onSuccess,
        onFailure: onFailure,
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
        preCall: preCall,
      );

  void paginatedApiCall<T extends BasePagination, E>(
    FutureResult<T> Function() apiCall,
    int pageKey, {
    void Function(T data)? onFirstPageFetched,
    Future<void> Function()? preCall,
  }) =>
      CubitStateHandlers.paginatedApiCall<T>(
        apiCall: apiCall,
        pageKey: pageKey,
        emit: emit,
        state: state as CommonState<T>,
        onFirstPageFetched: onFirstPageFetched,
        preCall: preCall,
      );
}
