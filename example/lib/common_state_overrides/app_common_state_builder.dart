// then define app widgets that call our widgets with specifying the error type too
import 'package:common_state/common_state.dart';
import 'package:example/common_state_overrides/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/error.dart';

class AppCommonStateBuilder<B extends StateStreamable<AppStates>, T> extends StatelessWidget {
  final int index;
  final Widget Function(T data) onSuccess;

  final Widget onLoading;
  final Widget onInit;
  final Widget onEmpty;
  final Widget Function(CustomErrorType exception) onError;

  const AppCommonStateBuilder({
    super.key,
    required this.index,
    required this.onSuccess,
    required this.onInit,
    required this.onEmpty,
    required this.onError,
    required this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CommonStateBuilder<B, T, CustomErrorType>(
      index: index,
      onSuccess: onSuccess,
      onLoading: onLoading,
      onInit: onInit,
      onEmpty: onEmpty,
      onError: onError,
    );
  }
}
