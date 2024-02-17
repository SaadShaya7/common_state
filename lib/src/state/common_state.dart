import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension StateChecker on CommonState {
  bool isInitial() => this is InitialState;

  bool isLoading() => this is LoadingState;

  bool isError() => this is ErrorState;

  bool isSuccess() => this is SuccessState;

  bool isEmpty() => this is EmptyState;

  E? getError<E>() {
    if (this is ErrorState) return (this as ErrorState).error as E;
    return null;
  }
}

abstract class CommonState<T, E> {
  const CommonState();
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  });
}

final class InitialState<T, E> extends CommonState<T, E> {
  const InitialState();
  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  }) =>
      initial();
}

final class LoadingState<T, E> extends CommonState<T, E> {
  const LoadingState();
  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  }) =>
      loading();
}

final class EmptyState<T, E> extends CommonState<T, E> {
  const EmptyState();
  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  }) =>
      empty();
}

final class ErrorState<T, E> extends CommonState<T, E> {
  final E error;

  const ErrorState(this.error);

  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  }) =>
      error(this.error);
}

final class SuccessState<T, E> extends CommonState<T, E> {
  final T data;

  const SuccessState(this.data);

  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  }) =>
      success(this.data);
}

final class PaginationClass<T, E> extends CommonState {
  final PagingController<int, T> pagingController;

  const PaginationClass({required this.pagingController});

  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  }) {
    ///this will not needed
    return const SizedBox() as Widget;
  }
}
