// ignore_for_file: invalid_use_of_protected_member

import 'package:common_state/src/state/state_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state.dart';

extension BlocExtension<Event, State extends StateObject<State>> on Bloc<Event, State> {
  void call<E extends Event, T>(
    FutureResult<T> Function(E event) call, {
    Future<void> Function(E event, Emitter<State> emit)? preCall,
    Future<void> Function(T data, E event, Emitter<State> emit)? onSuccess,
    Future<void> Function(dynamic failure, E event, Emitter<State> emit)? onFailure,
    bool Function(T)? emptyChecker,
    String? emptyMessage,
    String? stateName,
  }) =>
      on<E>(
        (event, emit) => StateHandler.call<T>(
          emit: emit,
          state: state,
          stateName: stateName,
          call: () => call(event),
          preCall: () async => preCall?.call(event, emit),
          onSuccess: (data) async => onSuccess?.call(data, event, emit),
          onFailure: (failure) async {
            addError(failure, StackTrace.current);
            await onFailure?.call(failure, event, emit);
          },
          emptyChecker: emptyChecker,
          emptyMessage: emptyMessage,
        ),
      );

  /// Used to handle paginated api calls for a bloc with multi [CommonState]
  /// [E] is the event type
  /// [T] is the data type
  void paginatedApiCall<E extends Event, T extends BasePagination>(
    FutureResult<T> Function(E event) call,
    int Function(E event) pageKey, {
    String? stateName,
    void Function(E event, Emitter<State> emit, T data)? onFirstPageFetched,
    Future<void> Function(E event, Emitter<State> emit)? preCall,
  }) =>
      on<E>(
        (event, emit) => StateHandler.paginatedApiCall<T>(
          preCall: () async => preCall?.call(event, emit),
          apiCall: () => call(event),
          stateName: stateName,
          pageKey: pageKey(event),
          emit: emit,
          state: state,
          onFirstPageFetched: (data) => onFirstPageFetched?.call(event, emit, data),
        ),
      );
}
