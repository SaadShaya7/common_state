import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:example/controllers/multi_state_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';

class MultiStateBloc extends Bloc<CommonStateEvent, MultiStateBlocState> {
  MultiStateBloc() : super(MultiStateBlocState()) {
    // Use this
    multiStateApiCall<Fetch, String>('state1', (event) => someUseCase());
    // or this
    on<Fetch>(
      (event, emit) => BlocStateHandlers.multiStateApiCall(
        apiCall: () => someUseCase(),
        emit: emit,
        state: state,
        stateName: 'state1',
      ),
    );
  }

  Future<Either<Error, String>> someUseCase() {
    return Future.delayed(const Duration(seconds: 3), () {
      return const Right('');
    });
  }
}
