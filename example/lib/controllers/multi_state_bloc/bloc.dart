import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:example/controllers/multi_state_bloc/state.dart';
import 'package:example/utils/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';

class MultiStateBloc extends Bloc<CommonStateEvent, MultiStateBlocState> {
  MultiStateBloc() : super(MultiStateBlocState()) {
    // Use this
    multiStateApiCall<Fetch, String, CustomErrorType>('state1', (event) => someUseCase());
  }

  Future<Either<CustomErrorType, String>> someUseCase() {
    return Future.delayed(const Duration(seconds: 2), () {
      return const Right('success');
    });
  }
}
