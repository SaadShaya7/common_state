import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:example/controllers/multi_state_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state_overrides/types.dart';
import 'event.dart';

class MultiStateBloc extends Bloc<CommonStateEvent, AppStates> {
  MultiStateBloc() : super(MultiStateBlocState.init) {
    on<CommonStateEvent>(
      (event, emit) => BlocStateHandlers.multiStateApiCall(
        callback: () async => const Right('true'),
        emit: emit,
        state: state,
        index: MultiStateBlocState.state1,
      ),
    );
    on<CommonStateEvent>(
      (event, emit) => BlocStateHandlers.multiStateApiCall(
        callback: () async => const Right('true'),
        emit: emit,
        state: state,
        index: MultiStateBlocState.state2,
      ),
    );
    on<CommonStateEvent>(
      (event, emit) => BlocStateHandlers.multiStateApiCall(
        callback: () async => const Right('true'),
        emit: emit,
        state: state,
        index: MultiStateBlocState.state3,
      ),
    );
    on<CommonStateEvent>(
      (event, emit) => BlocStateHandlers.multiStateApiCall(
        callback: () async => const Right('true'),
        emit: emit,
        state: state,
        index: MultiStateBlocState.state4,
      ),
    );
  }
}
