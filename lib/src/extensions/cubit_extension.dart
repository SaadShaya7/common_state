// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:common_state/common_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension MultiStateCubitExtension<State extends StateObject<State>> on Cubit<State> {
  void multiStateApiCall<T, E>(
    String stateName,
    FutureResult<T, E> Function() apiCall, {
    /// Optional callback to trigger in case of success
    Function(dynamic)? onSuccess,

    /// Optional callback to trigger in case of Failure
    Function(dynamic)? onFailure,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,

    /// Message to pass to empty state
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
      );

  void multiStatePaginatedApiCall<T extends BasePagination, E>(
          String stateName, FutureResult<PaginationModel<T>, E> Function() apiCall, int pageKey) =>
      CubitStateHandlers.multiStatePaginatedApiCall(
        apiCall: apiCall,
        pageKey: pageKey,
        emit: emit,
        state: state,
        stateName: stateName,
      );
}

extension CommonStateCubitExtension on Cubit<CommonState> {
  void apiCall<T, E>(
    FutureResult<T, E> Function() apiCall, {
    /// Optional callback to trigger in case of success
    Function(dynamic)? onSuccess,

    /// Optional callback to trigger in case of Failure
    Function(dynamic)? onFailure,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,

    /// Message to pass to empty state
    String? emptyMessage,
  }) =>
      CubitStateHandlers.apiCall<T, E>(
        apiCall: apiCall,
        emit: emit,
        onSuccess: onSuccess,
        onFailure: onFailure,
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
      );

  void paginatedApiCall<T extends BasePagination, E>(FutureResult<T, E> Function() apiCall, int pageKey) =>
      CubitStateHandlers.paginatedApiCall<T, E>(
        apiCall: apiCall,
        pageKey: pageKey,
        emit: emit,
        state: state as CommonState<T, E>,
      );
}
