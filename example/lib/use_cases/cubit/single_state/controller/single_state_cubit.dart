import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:example/models/error.dart';
import 'package:example/overrides/types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleStateCubit extends Cubit<AppCommonState<String>> {
  SingleStateCubit() : super(const Initial());

  void fetch() => apiCall<String, CustomErrorType>(
        () async {
          await Future.delayed(const Duration(seconds: 2));

          return const Right('Single state cubit succeeded!');
        },
      );
}
