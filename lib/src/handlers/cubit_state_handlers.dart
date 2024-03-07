import 'package:common_state/src/handlers/base_state_handler.dart';

import '../../common_state.dart';
import '../models/pagination_model.dart';

class CubitStateHandlers {
  static Future<void> apiCall<T, E>({
    required FutureResult<T, E> Function() callback,
    required void Function(CommonState<T, E>) emit,
    bool Function(T)? emptyChecker,
  }) =>
      BaseHandler.apiCall(
        callback: callback,
        emit: emit,
        emptyChecker: emptyChecker,
      );

  static Future<void> multiStateApiCall<T, E>({
    required FutureResult<T, E> Function() callback,
    required Function(StateObject) emit,
    required StateObject state,
    required String stateName,
    Function(T)? onSuccess,
    bool Function(T)? emptyChecker,
  }) =>
      BaseHandler.multiStateApiCall<T, E>(
        callback: callback,
        emit: emit,
        state: state,
        stateName: stateName,
        onSuccess: onSuccess,
        emptyChecker: emptyChecker,
      );

  static Future<void> multiStatePaginatedApiCall<T, E>({
    FutureResult<PaginationModel<T>, E> Function()? getData,
    PaginationModel<T>? data,
    required int pageKey,
    required Function(StateObject) emit,
    required StateObject state,
    required String stateName,
  }) =>
      BaseHandler.multiStatePaginatedApiCall<T, E>(
        pageKey: pageKey,
        emit: emit,
        state: state,
        stateName: stateName,
        getData: getData,
        data: data,
      );
}
