import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

abstract class CommonState<T, E> {
  final String? name;
  const CommonState([this.name]);
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) failure,
    required Widget Function(T) success,
    required Widget Function([String?]) empty,
  });
}

final class InitialState<T, E> extends CommonState<T, E> {
  const InitialState([super.name]);
  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) failure,
    required Widget Function(T) success,
    required Widget Function([String?]) empty,
  }) =>
      initial();
}

final class LoadingState<T, E> extends CommonState<T, E> {
  const LoadingState([super.name]);
  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) failure,
    required Widget Function(T) success,
    required Widget Function([String?]) empty,
  }) =>
      loading();
}

final class EmptyState<T, E> extends CommonState<T, E> {
  final String? message;
  const EmptyState([this.message]);
  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) failure,
    required Widget Function(T) success,
    required Widget Function([String?]) empty,
  }) =>
      empty(this.message);
}

final class FailureState<T, E> extends CommonState<T, E> {
  final E failure;

  const FailureState(this.failure, {String? name}) : super(name);

  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) failure,
    required Widget Function(T) success,
    required Widget Function([String?]) empty,
  }) =>
      failure(this.failure);
}

final class SuccessState<T, E> extends CommonState<T, E> {
  final T data;

  const SuccessState(this.data, {String? name}) : super(name);

  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(E) failure,
    required Widget Function(T) success,
    required Widget Function([String?]) empty,
  }) =>
      success(this.data);
}

final class PaginationState<T> extends CommonState {
  final PagingController<int, T> pagingController;

  PaginationState([super.name, PagingController<int, T>? pagingController])
      : pagingController = pagingController ?? PagingController<int, T>(firstPageKey: 1);

  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(dynamic) failure,
    required Widget Function(T) success,
    required Widget Function([String?]) empty,
  }) {
    return const SizedBox() as Widget;
  }
}
