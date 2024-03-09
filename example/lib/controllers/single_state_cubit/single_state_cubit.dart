import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:example/common_state_overrides/types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleStateCubit extends Cubit<AppCommonState<String>> {
  SingleStateCubit() : super(const Initial());

  void fetch() => apiCall(() async => const Right('Hello world'));
}
