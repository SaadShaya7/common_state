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
  const CommonState({this.name});
  final String? name;
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) error,
    required Widget Function(T) success,
    required Widget Function() empty,
  });
}

final class InitialState<T, E> extends CommonState<T, E> {
  const InitialState({super.name});
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
  const LoadingState({super.name});
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
  const EmptyState({super.name});
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

  const ErrorState(this.error, {super.name});

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

  const SuccessState(this.data, {super.name});

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

  const PaginationClass({required this.pagingController, super.name});

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

final class StateKey<T, E> extends CommonState<T, E> {
  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E p1) error,
    required Widget Function(T p1) success,
    required Widget Function() empty,
  }) {
    // TODO: implement when
    throw UnimplementedError();
  }
}
