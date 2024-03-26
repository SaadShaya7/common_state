import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultBuilder<B extends StateStreamable<BaseState>, T> extends StatelessWidget {
  const ResultBuilder({
    Key? key,
    required this.loaded,
    required this.empty,
    required this.initial,
    required this.loading,
    required this.failure,
    this.stateName,
  }) : super(key: key);

  final Widget Function(T data) loaded;
  final Widget Function(dynamic failure) failure;
  final Widget Function(String? message) empty;
  final Widget initial;
  final Widget loading;
  final String? stateName;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, BaseState, CommonState<T>>(
      selector: (state) {
        if (state is CommonState<T>) return state;

        if (state is StateObject) {
          if (stateName == null) {
            throw ArgumentError('State name not provided for StateObject in ResultBuilder widget');
          }
          return state.getState(stateName!) as CommonState<T>;
        }

        throw UnsupportedError('Unsupported state type given to ResultBuilder widget');
      },
      builder: (context, state) => state.when(
        initial: () => initial,
        loading: () => loading,
        failure: (error) => failure(error),
        empty: ([message]) => empty(message),
        success: (data) => loaded(data),
      ),
    );
  }
}
