import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:example/controllers/mutli_state_cubit/mutli_state_cubit_state.dart';
import 'package:example/utils/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_state_overrides/types.dart';

class MultiStateCubit extends Cubit<AppStates> {
  MultiStateCubit() : super(MultiStateCubitState.init);

  get() async => CubitStateHandlers.handleMultiStateApiCall<dynamic, CustomErrorType>(
        callback: () async => const Right("Success"),
        emit: emit,
        state: state,
        index: MultiStateCubitState.state1,
      );
}
