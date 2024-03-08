import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [B] is Bloc
/// [T] is the return type
/// [E] is Error  type
class CommonStateBuilder<B extends StateStreamable<StateObject>, T, E> extends StatelessWidget {
  const CommonStateBuilder({
    super.key,
    required this.stateName,
    required this.loaded,
    required this.loading,
    required this.initial,
    required this.empty,
    required this.failure,
  });

  final String stateName;
  final Widget Function(T data) loaded;

  final Widget loading;
  final Widget initial;
  final Widget Function(String? message) empty;
  final Widget Function(E exception) failure;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, StateObject, CommonState>(
      selector: (state) => state.getState(stateName),
      builder: (context, state) {
        return state.when(
          initial: () => initial,
          loading: () => loading,
          error: (r) => failure(r),
          success: (data) => loaded(data),
          empty: ([message]) => empty(message),
        );
      },
    );
  }
}
