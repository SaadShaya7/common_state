import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

extension StateChecker<T, E> on CommonState<T, E> {
  bool get isInitial => this is InitialState;

  bool get isLoading => this is LoadingState;

  bool get isError => this is ErrorState;

  bool get isSuccess => this is SuccessState;

  bool get isEmpty => this is EmptyState;

  E? get getError {
    if (this is ErrorState) return (this as ErrorState).error;
    return null;
  }

  T? get data {
    if (this is SuccessState<T, E>) return this.data;
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

final class PaginationState<T> extends CommonState {
  final PagingController<int, T> pagingController;

  PaginationState([PagingController<int, T>? pagingController])
      : pagingController = pagingController ?? PagingController<int, T>(firstPageKey: 1);

  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(dynamic) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  }) {
    return const SizedBox() as Widget;
  }
}
