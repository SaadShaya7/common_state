// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:common_state/common_state.dart';
import 'package:common_state/src/handlers/base_state_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension CommonStateCubitExtension on Cubit<BaseState> {
  void apiCall<T>(
    FutureResult<T> Function() apiCall, {
    Future<void> Function()? preCall,
    Future<void> Function(T data)? onSuccess,
    Future<void> Function(dynamic error)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
    String? stateName,
  }) =>
      BaseHandler.apiCall<T>(
        apiCall: apiCall,
        stateName: stateName,
        emit: emit,
        state: state,
        onSuccess: onSuccess,
        onFailure: (failure) async {
          addError(failure, StackTrace.current);
          await onFailure?.call(failure);
        },
        emptyChecker: emptyChecker,
        emptyMessage: emptyMessage,
        preCall: preCall,
      );

  // ignore: avoid_shadowing_type_parameters
  void paginatedApiCall<T extends BasePagination, P>(
    FutureResult<T> Function() apiCall,
    int pageKey, {
    void Function(T data)? onFirstPageFetched,
    Future<void> Function()? preCall,
    bool Function(T data)? isLastPage,
    String? stateName,
  }) =>
      BaseHandler.paginatedApiCall<T>(
        apiCall: apiCall,
        pageKey: pageKey,
        emit: emit as void Function(PaginationState<BasePagination, P>),
        state: state as PaginationState<T, P>,
        onFirstPageFetched: onFirstPageFetched,
        preCall: preCall,
        isLastPage: isLastPage,
        stateName: stateName,
      );
}
