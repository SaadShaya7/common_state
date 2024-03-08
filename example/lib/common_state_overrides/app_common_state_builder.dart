// then define app widgets that call our widgets with specifying the error type too
import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/error.dart';

class AppCommonStateBuilder<B extends StateStreamable<StateObject>, T> extends StatelessWidget {
  final String stateName;
  final Widget Function(T data) loaded;

  final Widget? loading;
  final Widget? initial;
  final Widget Function([String? message])? empty;
  final Widget Function(CustomErrorType exception)? failure;

  const AppCommonStateBuilder({
    super.key,
    required this.stateName,
    required this.loaded,
    this.initial,
    this.empty,
    this.failure,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return CommonStateBuilder<B, T, CustomErrorType>(
      stateName: stateName,
      loaded: (data) => const Center(
        child: Text('Success', style: TextStyle(fontSize: 30)),
      ),
      loading: loading ??
          const Center(
            child: Text('loading', style: TextStyle(fontSize: 30)),
          ),
      initial: initial ??
          const Center(
            child: Text('init', style: TextStyle(fontSize: 30)),
          ),
      empty: empty ??
          ([message]) => const Center(
                child: Text('empty', style: TextStyle(fontSize: 30)),
              ),
      failure: failure ?? (error) => Text(error.toString()),
    );
  }
}
