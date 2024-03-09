import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum CommonStatePaginationType {
  pagedListView,
  pagedGridView,
  pagedSliverList,
  pagedSliverGrid,
  pagedPageView
}

/// B is Bloc
/// T is Pagination Data type
class CommonStatePaginationBuilder<B extends StateStreamable<StateObject>, T>
    extends StatefulWidget {
  const CommonStatePaginationBuilder.pagedListView({
    super.key,
    required this.stateName,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.firstPageErrorIndicatorBuilder,
    required this.firstPageProgressIndicatorBuilder,
    required this.newPageErrorIndicatorBuilder,
    required this.newPageProgressIndicatorBuilder,
    required this.noItemsFoundIndicatorBuilder,
    required this.noMoreItemsIndicatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.shrinkWrap = false,
  })
      : _type = CommonStatePaginationType.pagedListView,
        gridDelegate = null;

  const CommonStatePaginationBuilder.pagedGridView({
    super.key,
    required this.stateName,
    required this.itemBuilder,
    required this.firstPageErrorIndicatorBuilder,
    required this.firstPageProgressIndicatorBuilder,
    required this.newPageErrorIndicatorBuilder,
    required this.newPageProgressIndicatorBuilder,
    required this.noItemsFoundIndicatorBuilder,
    required this.noMoreItemsIndicatorBuilder,
    required this.gridDelegate,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.shrinkWrap = false,
  })
      : _type = CommonStatePaginationType.pagedGridView,
        separatorBuilder = null;

  const CommonStatePaginationBuilder.pagedSliverList({
    super.key,
    required this.stateName,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.firstPageErrorIndicatorBuilder,
    required this.firstPageProgressIndicatorBuilder,
    required this.newPageErrorIndicatorBuilder,
    required this.newPageProgressIndicatorBuilder,
    required this.noItemsFoundIndicatorBuilder,
    required this.noMoreItemsIndicatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.shrinkWrap = false,
  })
      : _type = CommonStatePaginationType.pagedSliverList,
        gridDelegate = null;

  const CommonStatePaginationBuilder.pagedSliverGrid({
    super.key,
    required this.stateName,
    required this.itemBuilder,
    required this.firstPageErrorIndicatorBuilder,
    required this.firstPageProgressIndicatorBuilder,
    required this.newPageErrorIndicatorBuilder,
    required this.newPageProgressIndicatorBuilder,
    required this.noItemsFoundIndicatorBuilder,
    required this.noMoreItemsIndicatorBuilder,
    required this.gridDelegate,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.shrinkWrap = false,
  })
      : _type = CommonStatePaginationType.pagedSliverGrid,
        separatorBuilder = null;

  const CommonStatePaginationBuilder.pagedPageView({
    super.key,
    required this.stateName,
    required this.itemBuilder,
    this.separatorBuilder,
    required this.firstPageErrorIndicatorBuilder,
    required this.firstPageProgressIndicatorBuilder,
    required this.newPageErrorIndicatorBuilder,
    required this.newPageProgressIndicatorBuilder,
    required this.noItemsFoundIndicatorBuilder,
    required this.noMoreItemsIndicatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.shrinkWrap = false,
  })
      : _type = CommonStatePaginationType.pagedPageView,
        gridDelegate = null;

  final String stateName;
  final bool shrinkWrap;

  final ItemWidgetBuilder<T> itemBuilder;
  final Widget? firstPageErrorIndicatorBuilder;
  final Widget? firstPageProgressIndicatorBuilder;
  final Widget? newPageErrorIndicatorBuilder;
  final Widget? newPageProgressIndicatorBuilder;
  final Widget? noItemsFoundIndicatorBuilder;
  final Widget? noMoreItemsIndicatorBuilder;
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final CommonStatePaginationType _type;
  final SliverGridDelegate? gridDelegate;
  final IndexedWidgetBuilder? separatorBuilder;
  final ValueChanged<int>? onPageKeyChanged;

  @override
  State<CommonStatePaginationBuilder<B, T>> createState() =>
      _CommonStatePaginationBuilderState<B, T>();
}

class _CommonStatePaginationBuilderState<B extends StateStreamable<
    StateObject>, T> extends State<CommonStatePaginationBuilder<B, T>> {
  @override
  void initState() {
    super.initState();

    if (widget.onPageKeyChanged == null) return;

    final commonState = context
        .read<B>()
        .state
        .getState(widget.stateName);
    if (commonState is! PaginationState<T>) {
      throw Exception(
          '${commonState.runtimeType} is not of type PaginationState<$T>');
    }

    final PaginationState<T> paginationState = commonState;

    paginationState.pagingController.addPageRequestListener((pageKey) =>
        widget.onPageKeyChanged!(pageKey));
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, StateObject, PaginationState<T>>(
      selector: (state) {
        final selectedState = state.getState(widget.stateName);
        if (selectedState is! PaginationState<T>) {
          throw Exception('${state.runtimeType} is not of type PaginationState<$T>');
        }
        return selectedState;
      },
      builder: (context, state) {
        switch (widget._type) {
          case CommonStatePaginationType.pagedGridView:
            return PagedGridView<int, T>(
              shrinkWrap: widget.shrinkWrap,
              pagingController: state.pagingController,
              builderDelegate: PagedChildBuilderDelegate<T>(
                  itemBuilder: widget.itemBuilder,
                  firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder != null
                      ? (context) => widget.firstPageErrorIndicatorBuilder!
                      : null,
                  firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder != null
                      ? ((context) => widget.firstPageProgressIndicatorBuilder!)
                      : null,
                  newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder != null
                      ? ((context) => widget.newPageErrorIndicatorBuilder!)
                      : null,
                  newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder != null
                      ? ((context) => widget.newPageProgressIndicatorBuilder!)
                      : null,
                  noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder != null
                      ? ((context) => widget.noItemsFoundIndicatorBuilder!)
                      : null,
                  noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder != null
                      ? ((context) => widget.noMoreItemsIndicatorBuilder!)
                      : null),
              gridDelegate: widget.gridDelegate!,
            );
          case CommonStatePaginationType.pagedListView:
            if (widget.separatorBuilder != null) {
              return PagedListView<int, T>.separated(
                separatorBuilder: widget.separatorBuilder!,
                padding: widget.padding,
                scrollDirection: widget.scrollDirection,
                physics: widget.physics,
                pagingController: (state).pagingController,
                builderDelegate: PagedChildBuilderDelegate<T>(
                    itemBuilder: widget.itemBuilder,
                    firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder != null
                        ? (context) => widget.firstPageErrorIndicatorBuilder!
                        : null,
                    firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder != null
                        ? ((context) => widget.firstPageProgressIndicatorBuilder!)
                        : null,
                    newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder != null
                        ? ((context) => widget.newPageErrorIndicatorBuilder!)
                        : null,
                    newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder != null
                        ? ((context) => widget.newPageProgressIndicatorBuilder!)
                        : null,
                    noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder != null
                        ? ((context) => widget.noItemsFoundIndicatorBuilder!)
                        : null,
                    noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder != null
                        ? ((context) => widget.noMoreItemsIndicatorBuilder!)
                        : null),
              );
            }
            return PagedListView<int, T>(
              padding: widget.padding,
              scrollDirection: widget.scrollDirection,
              physics: widget.physics,
              pagingController: (state).pagingController,
              builderDelegate: PagedChildBuilderDelegate<T>(
                  itemBuilder: widget.itemBuilder,
                  firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder != null
                      ? (context) => widget.firstPageErrorIndicatorBuilder!
                      : null,
                  firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder != null
                      ? ((context) => widget.firstPageProgressIndicatorBuilder!)
                      : null,
                  newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder != null
                      ? ((context) => widget.newPageErrorIndicatorBuilder!)
                      : null,
                  newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder != null
                      ? ((context) => widget.newPageProgressIndicatorBuilder!)
                      : null,
                  noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder != null
                      ? ((context) => widget.noItemsFoundIndicatorBuilder!)
                      : null,
                  noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder != null
                      ? ((context) => widget.noMoreItemsIndicatorBuilder!)
                      : null),
            );
          case CommonStatePaginationType.pagedSliverList:
            if (widget.separatorBuilder != null) {
              return PagedSliverList<int, T>.separated(
                  separatorBuilder: widget.separatorBuilder!,
                  pagingController: (state).pagingController,
                  builderDelegate: PagedChildBuilderDelegate<T>(
                      itemBuilder: widget.itemBuilder,
                      firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder != null
                          ? (context) => widget.firstPageErrorIndicatorBuilder!
                          : null,
                      firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder != null
                          ? ((context) => widget.firstPageProgressIndicatorBuilder!)
                          : null,
                      newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder != null
                          ? ((context) => widget.newPageErrorIndicatorBuilder!)
                          : null,
                      newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder != null
                          ? ((context) => widget.newPageProgressIndicatorBuilder!)
                          : null,
                      noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder != null
                          ? ((context) => widget.noItemsFoundIndicatorBuilder!)
                          : null,
                      noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder != null
                          ? ((context) => widget.noMoreItemsIndicatorBuilder!)
                          : null));
            }
            return PagedSliverList<int, T>(
                pagingController: (state).pagingController,
                builderDelegate: PagedChildBuilderDelegate<T>(
                    itemBuilder: widget.itemBuilder,
                    firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder != null
                        ? (context) => widget.firstPageErrorIndicatorBuilder!
                        : null,
                    firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder != null
                        ? ((context) => widget.firstPageProgressIndicatorBuilder!)
                        : null,
                    newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder != null
                        ? ((context) => widget.newPageErrorIndicatorBuilder!)
                        : null,
                    newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder != null
                        ? ((context) => widget.newPageProgressIndicatorBuilder!)
                        : null,
                    noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder != null
                        ? ((context) => widget.noItemsFoundIndicatorBuilder!)
                        : null,
                    noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder != null
                        ? ((context) => widget.noMoreItemsIndicatorBuilder!)
                        : null));
          case CommonStatePaginationType.pagedSliverGrid:
            return PagedSliverGrid<int, T>(
              pagingController: (state).pagingController,
              builderDelegate: PagedChildBuilderDelegate<T>(
                  itemBuilder: widget.itemBuilder,
                  firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder != null
                      ? (context) => widget.firstPageErrorIndicatorBuilder!
                      : null,
                  firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder != null
                      ? ((context) => widget.firstPageProgressIndicatorBuilder!)
                      : null,
                  newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder != null
                      ? ((context) => widget.newPageErrorIndicatorBuilder!)
                      : null,
                  newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder != null
                      ? ((context) => widget.newPageProgressIndicatorBuilder!)
                      : null,
                  noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder != null
                      ? ((context) => widget.noItemsFoundIndicatorBuilder!)
                      : null,
                  noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder != null
                      ? ((context) => widget.noMoreItemsIndicatorBuilder!)
                      : null),
              gridDelegate: widget.gridDelegate!,
            );
          default:
            if (widget.separatorBuilder != null) {
              PagedListView<int, T>.separated(
                separatorBuilder: widget.separatorBuilder!,
                padding: widget.padding,
                scrollDirection: widget.scrollDirection,
                physics: widget.physics,
                pagingController: (state).pagingController,
                builderDelegate: PagedChildBuilderDelegate<T>(
                    itemBuilder: widget.itemBuilder,
                    firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder != null
                        ? (context) => widget.firstPageErrorIndicatorBuilder!
                        : null,
                    firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder != null
                        ? ((context) => widget.firstPageProgressIndicatorBuilder!)
                        : null,
                    newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder != null
                        ? ((context) => widget.newPageErrorIndicatorBuilder!)
                        : null,
                    newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder != null
                        ? ((context) => widget.newPageProgressIndicatorBuilder!)
                        : null,
                    noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder != null
                        ? ((context) => widget.noItemsFoundIndicatorBuilder!)
                        : null,
                    noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder != null
                        ? ((context) => widget.noMoreItemsIndicatorBuilder!)
                        : null),
              );
            }
            return PagedListView<int, T>(
              padding: widget.padding,
              scrollDirection: widget.scrollDirection,
              physics: widget.physics,
              pagingController: (state).pagingController,
              builderDelegate: PagedChildBuilderDelegate<T>(
                  itemBuilder: widget.itemBuilder,
                  firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder != null
                      ? (context) => widget.firstPageErrorIndicatorBuilder!
                      : null,
                  firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder != null
                      ? ((context) => widget.firstPageProgressIndicatorBuilder!)
                      : null,
                  newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder != null
                      ? ((context) => widget.newPageErrorIndicatorBuilder!)
                      : null,
                  newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder != null
                      ? ((context) => widget.newPageProgressIndicatorBuilder!)
                      : null,
                  noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder != null
                      ? ((context) => widget.noItemsFoundIndicatorBuilder!)
                      : null,
                  noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder != null
                      ? ((context) => widget.noMoreItemsIndicatorBuilder!)
                      : null),
            );
        }
      },
    );
  }
}
