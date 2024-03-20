import 'package:common_state/common_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

abstract class CommonState<T, E> extends BaseState {
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

final class PaginationState<T extends BasePagination, P> extends CommonState {
  final PagingController<int, P> pagingController;

  PaginationState([super.name, PagingController<int, P>? pagingController])
      : pagingController = pagingController ?? PagingController<int, P>(firstPageKey: 0);

  @override
  Widget when<Widget>({
    required Widget Function() initial,
    required Widget Function() loading,
    required Widget Function(dynamic) failure,
    required Widget Function(T) success,
    required Widget Function([String?]) empty,
  }) =>
      const SizedBox.shrink() as Widget;
}
