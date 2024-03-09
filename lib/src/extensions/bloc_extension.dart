import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';

extension BlocExtension<Event, State extends StateObject<State>> on Bloc<Event, State> {
  void multiStateApiCall<E extends Event, T>(
    String stateName,
    FutureResult<T, dynamic> Function(E event) apiCall, {
    /// Optional callback to trigger in case of success
    void Function(T data)? onSuccess,

    /// Optional callback to trigger in case of Failure
    void Function(dynamic failure)? onFailure,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,

    /// Message to pass to empty state
    String? emptyMessage,
  }) =>
      on<E>(
        (event, emit) => BlocStateHandlers.multiStateApiCall<T, dynamic>(
          apiCall: () => apiCall(event),
          emit: emit,
          state: state,
          stateName: stateName,
          onSuccess: onSuccess,
          onFailure: onFailure,
          emptyChecker: emptyChecker,
          emptyMessage: emptyMessage,
        ),
      );

  void multiStatePaginatedApiCall<E extends Event>(
    String stateName,
    FutureResult Function(E event) apiCall,
    int pageKey,
  ) =>
      on<E>(
        (event, emit) => BlocStateHandlers.multiStatePaginatedApiCall(
          apiCall: () => apiCall(event),
          pageKey: pageKey,
          emit: emit,
          state: state,
          stateName: stateName,
        ),
      );
}
