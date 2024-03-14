import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';

extension BlocExtension<Event, State extends StateObject<State>> on Bloc<Event, State> {
  void multiStateApiCall<E extends Event, T, F>(
    String stateName,
    CommonStateFutureResult<T, F> Function(E event) apiCall, {
    /// Optional callback to trigger in case of success
    void Function(T data, E event, Emitter<State> emit)? onSuccess,

    /// Optional callback to trigger in case of Failure
    void Function(F failure, E event, Emitter<State> emit)? onFailure,
    void Function(E event, Emitter<State> emit)? preCall,

    /// Function to check if data is empty, if not provided the function will check if the data is a list and empty by default
    bool Function(T)? emptyChecker,

    /// Message to pass to empty state
    String? emptyMessage,
  }) =>
      on<E>(
        (event, emit) => BlocStateHandlers.multiStateApiCall<T, F>(
          emit: emit,
          state: state,
          stateName: stateName,
          apiCall: () => apiCall(event),
          preCall: () => preCall?.call(event, emit),
          onSuccess: (data) => onSuccess?.call(data, event, emit),
          onFailure: (failure) => onFailure?.call(failure, event, emit),
          emptyChecker: emptyChecker,
          emptyMessage: emptyMessage,
        ),
      );

  /// Used to handle paginated api calls for a bloc with multi [CommonState]
  /// [E] is the event type
  /// [T] is the data type
  /// [F] is the failure type
  void multiStatePaginatedApiCall<E extends Event, T extends BasePagination>(
    String stateName,
    CommonStateFutureResult<T, dynamic> Function(E event) apiCall,
    int Function(E event) pageKey, {
    void Function(E event, Emitter<State> emit, T data)? onFirstPageFetched,
  }) =>
      on<E>(
        (event, emit) => BlocStateHandlers.multiStatePaginatedApiCall<T, dynamic>(
          apiCall: () => apiCall(event),
          stateName: stateName,
          pageKey: pageKey(event),
          emit: emit,
          state: state,
          onFirstPageFetched: (data) => onFirstPageFetched?.call(event, emit, data),
        ),
      );
}
