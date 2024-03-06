import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// B is Bloc
/// T is the return type
/// E is Error  type
class CommonStateBuilder<B extends StateStreamable<StateObject>, T, E> extends StatelessWidget {
  const CommonStateBuilder({
    super.key,
    required this.stateName,
    required this.onSuccess,
    required this.onLoading,
    required this.onInit,
    required this.onEmpty,
    required this.onError,
  });

  final String stateName;
  final Widget Function(T data) onSuccess;
  final Widget onLoading;

  final Widget onInit;
  final Widget onEmpty;
  final Widget Function(E exception) onError;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, StateObject, CommonState>(
      selector: (state) => state.getState(stateName),
      builder: (context, state) {
        print('common state builder Rebuilt, the current state is $state');
        if (state is PaginationState) {
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
