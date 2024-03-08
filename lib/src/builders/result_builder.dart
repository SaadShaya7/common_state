import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/common_state.dart';

class ResultBuilder<B extends StateStreamable<CommonState<T, E>>, T, E> extends StatelessWidget {
  const ResultBuilder({
    Key? key,
    required this.loaded,
    required this.empty,
    required this.initial,
    required this.loading,
    required this.fail,
  }) : super(key: key);

  final Widget Function(T data) loaded;
  final Widget Function() initial;
  final Widget Function() loading;
  final Widget Function(E failure) fail;
  final Widget Function(String? message) empty;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, CommonState<T, E>>(
      builder: (context, state) => state.when(
        initial: () => initial(),
        loading: () => loading(),
        error: (failure) => fail(failure),
        empty: ([message]) => empty(message),
        success: (data) => loaded(data),
      ),
    );
  }
}
