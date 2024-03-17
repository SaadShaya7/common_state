import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';

extension BlocExtension<Event, State extends StateObject<State>> on Bloc<Event, State> {
  void multiStateApiCall<E extends Event, T, F>(
    String stateName,
    CommonStateFutureResult<T, F> Function(E event) apiCall, {
    Future<void> Function(E event, Emitter<State> emit)? preCall,
    void Function(T data, E event, Emitter<State> emit)? onSuccess,
    void Function(F failure, E event, Emitter<State> emit)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
  }) =>
      on<E>(
        (event, emit) => BlocStateHandlers.multiStateApiCall<T, F>(
          emit: emit,
          state: state,
          stateName: stateName,
          apiCall: () => apiCall(event),
          preCall: () async => preCall?.call(event, emit),
          onSuccess: (data) => onSuccess?.call(data, event, emit),
          onFailure: (failure) => onFailure?.call(failure, event, emit),
          emptyChecker: emptyChecker,
          emptyMessage: emptyMessage,
        ),
      );

  /// Used to handle paginated api calls for a bloc with multi [CommonState]
  /// [E] is the event type
  /// [T] is the data type
  void multiStatePaginatedApiCall<E extends Event, T extends BasePagination>(
    String stateName,
    CommonStateFutureResult<T, dynamic> Function(E event) apiCall,
    int Function(E event) pageKey, {
    void Function(E event, Emitter<State> emit, T data)? onFirstPageFetched,
    Future<void> Function(E event, Emitter<State> emit)? preCall,
  }) =>
      on<E>(
        (event, emit) => BlocStateHandlers.multiStatePaginatedApiCall<T, dynamic>(
          preCall: () async => preCall?.call(event, emit),
          apiCall: () => apiCall(event),
          stateName: stateName,
          pageKey: pageKey(event),
          emit: emit,
          state: state,
          onFirstPageFetched: (data) => onFirstPageFetched?.call(event, emit, data),
        ),
      );
}
