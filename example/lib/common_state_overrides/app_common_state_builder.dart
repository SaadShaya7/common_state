// then define app widgets that call our widgets with specifying the error type too
import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/error.dart';

class AppCommonStateBuilder<B extends StateStreamable<StateObject>, T> extends StatelessWidget {
  final String stateName;
  final Widget Function(T data) onSuccess;

  final Widget? onLoading;
  final Widget? onInit;
  final Widget? onEmpty;
  final Widget Function(CustomErrorType exception)? onError;

  const AppCommonStateBuilder({
    super.key,
    required this.stateName,
    required this.onSuccess,
    this.onInit,
    this.onEmpty,
    this.onError,
    this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CommonStateBuilder<B, T, CustomErrorType>(
      stateName: stateName,
      onSuccess: (data) => const Center(
        child: Text('Success', style: TextStyle(fontSize: 30)),
      ),
      onLoading: onLoading ??
          const Center(
            child: Text('loading', style: TextStyle(fontSize: 30)),
          ),
      onInit: onInit ??
          const Center(
            child: Text('init', style: TextStyle(fontSize: 30)),
          ),
      onEmpty: onEmpty ??
          const Center(
            child: Text('Empty', style: TextStyle(fontSize: 30)),
          ),
      onError: onError ?? (error) => Text(error.toString()),
    );
  }
}
