import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/common_state.dart';

/// B is Bloc
/// T is the return type
/// E is Error  type
class CommonStateBuilder<B extends StateStreamable<Map<int, CommonState>>, T, E> extends StatelessWidget {
  const CommonStateBuilder({
    super.key,
    required this.index,
    required this.onSuccess,
    required this.onLoading,
    required this.onInit,
    required this.onEmpty,
    required this.onError,
  });

  final int index;
  final Widget Function(T data) onSuccess;
  final Widget onLoading;

  final Widget onInit;
  final Widget onEmpty;
  final Widget Function(E exception) onError;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, Map<int, CommonState>, CommonState<T, E>>(
      selector: (state) => state[index] as CommonState<T, E>,
      builder: (context, state) {
        if (state is PaginationClass) {
          return const Text("Pagination");
        } else {
          return state.when(
            initial: () => onInit,
            loading: () => onLoading,
            error: (r) => onError(r),
            success: (data) => onSuccess(data),
            empty: () => onEmpty,
          );
        }
      },
    );
  }
}
