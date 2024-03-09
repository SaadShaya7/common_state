import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';

extension BlocExtension<Event, State extends StateObject<State>> on Bloc<Event, State> {
  void multiStateApiCall<E extends Event, T, F>(
    String stateName,
    FutureResult<T, F> Function(E event) apiCall, {
    /// Optional callback to trigger in case of success
    void Function(T data, E event)? onSuccess,

    /// Optional callback to trigger in case of Failure
    void Function(F failure, E event)? onFailure,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,

    /// Message to pass to empty state
    String? emptyMessage,
  }) =>
      on<E>(
        (event, emit) => BlocStateHandlers.multiStateApiCall<T, F>(
          apiCall: () => apiCall(event),
          emit: emit,
          state: state,
          stateName: stateName,
          onSuccess: (data) => onSuccess?.call(data, event),
          onFailure: (failure) => onFailure?.call(failure, event),
          emptyChecker: emptyChecker,
          emptyMessage: emptyMessage,
        ),
      );

  void multiStatePaginatedApiCall<E extends Event, T>(
    String stateName,
    FutureResult<PaginationModel<T>, dynamic> Function(E event) apiCall,
    int Function(E event) pageKey,
  ) =>
      on<E>(
        (event, emit) => BlocStateHandlers.multiStatePaginatedApiCall<T, dynamic>(
          apiCall: () => apiCall(event),
          pageKey: pageKey(event),
          emit: emit,
          state: state,
          stateName: stateName,
        ),
      );
}
