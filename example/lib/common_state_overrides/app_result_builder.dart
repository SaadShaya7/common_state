import 'package:common_state/common_state.dart';
import 'package:example/utils/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppResultBuilder<B extends StateStreamable<BaseState>, T> extends StatelessWidget {
  const AppResultBuilder({
    Key? key,
    required this.loaded,
    this.empty,
    this.initial,
    this.loading,
    this.failure,
    this.stateName,
  }) : super(key: key);

  final String? stateName;
  final Widget Function(T data) loaded;

  final Widget Function(CustomErrorType failure)? failure;
  final Widget Function(String? message)? empty;
  final Widget? initial;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return ResultBuilder<B, T, CustomErrorType>(
      stateName: stateName,
      loaded: loaded,
      empty: empty ?? (_) => const Text('empty'),
      initial: initial ?? const Text('initial'),
      loading: loading ?? const Text('loading'),
      failure: failure ?? (_) => const Text('failure'),
    );
  }
}
