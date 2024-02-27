import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../common_state.dart';

/// B is Bloc
/// T is Enum and should extends from Helper
/// D is data
/// [Example ] CommonStateBuilder<HomeBloc>(state: TestState.getProduct),
enum CommonStatePaginationType {
  pagedListView,
  pagedGridView,
  pagedSliverList,
  pagedSliverGrid,
  pagedMasonryGrid,
  pagedPageView
}

class CommonStatePaginationBuilder<B extends StateStreamable<Map<int, CommonState>>, T>
    extends StatelessWidget {
  const CommonStatePaginationBuilder.pagedListView(
      {super.key,
      required this.index,
      required this.itemBuilder,
      required this.firstPageErrorIndicatorBuilder,
      required this.firstPageProgressIndicatorBuilder,
      required this.newPageErrorIndicatorBuilder,
      required this.newPageProgressIndicatorBuilder,
      required this.noItemsFoundIndicatorBuilder,
      required this.noMoreItemsIndicatorBuilder,
      this.padding,
      this.scrollDirection = Axis.vertical,
      this.physics,
      this.shrinkWrap = false,
      this.gridDelegate})
      : _type = CommonStatePaginationType.pagedListView;

  const CommonStatePaginationBuilder.pagedGridView(
      {super.key,
      required this.index,
      required this.itemBuilder,
      required this.firstPageErrorIndicatorBuilder,
      required this.firstPageProgressIndicatorBuilder,
      required this.newPageErrorIndicatorBuilder,
      required this.newPageProgressIndicatorBuilder,
      required this.noItemsFoundIndicatorBuilder,
      required this.noMoreItemsIndicatorBuilder,
      this.padding,
      this.scrollDirection = Axis.vertical,
      this.physics,
      this.shrinkWrap = false,
      this.gridDelegate})
      : _type = CommonStatePaginationType.pagedGridView;

  const CommonStatePaginationBuilder.pagedSliverList(
      {super.key,
      required this.index,
      required this.itemBuilder,
      required this.firstPageErrorIndicatorBuilder,
      required this.firstPageProgressIndicatorBuilder,
      required this.newPageErrorIndicatorBuilder,
      required this.newPageProgressIndicatorBuilder,
      required this.noItemsFoundIndicatorBuilder,
      required this.noMoreItemsIndicatorBuilder,
      this.padding,
      this.scrollDirection = Axis.vertical,
      this.physics,
      this.shrinkWrap = false,
      this.gridDelegate})
      : _type = CommonStatePaginationType.pagedSliverList;

  const CommonStatePaginationBuilder.pagedSliverGrid({
    super.key,
    required this.index,
    required this.itemBuilder,
    required this.firstPageErrorIndicatorBuilder,
    required this.firstPageProgressIndicatorBuilder,
    required this.newPageErrorIndicatorBuilder,
    required this.newPageProgressIndicatorBuilder,
    required this.noItemsFoundIndicatorBuilder,
    required this.noMoreItemsIndicatorBuilder,
    required this.gridDelegate,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.shrinkWrap = false,
  }) : _type = CommonStatePaginationType.pagedSliverGrid;

  const CommonStatePaginationBuilder.pagedMasonryGrid(
      {super.key,
      required this.index,
      required this.itemBuilder,
      required this.firstPageErrorIndicatorBuilder,
      required this.firstPageProgressIndicatorBuilder,
      required this.newPageErrorIndicatorBuilder,
      required this.newPageProgressIndicatorBuilder,
      required this.noItemsFoundIndicatorBuilder,
      required this.noMoreItemsIndicatorBuilder,
      this.padding,
      this.scrollDirection = Axis.vertical,
      this.physics,
      this.shrinkWrap = false,
      this.gridDelegate})
      : _type = CommonStatePaginationType.pagedMasonryGrid;

  const CommonStatePaginationBuilder.pagedPageView(
      {super.key,
      required this.index,
      required this.itemBuilder,
      required this.firstPageErrorIndicatorBuilder,
      required this.firstPageProgressIndicatorBuilder,
      required this.newPageErrorIndicatorBuilder,
      required this.newPageProgressIndicatorBuilder,
      required this.noItemsFoundIndicatorBuilder,
      required this.noMoreItemsIndicatorBuilder,
      this.padding,
      this.scrollDirection = Axis.vertical,
      this.physics,
      this.shrinkWrap = false,
      this.gridDelegate})
      : _type = CommonStatePaginationType.pagedPageView;

  final int index;
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

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, Map<int, CommonState>, CommonState>(
      selector: (state) => state[index]!,
      builder: (context, state) {
        if (state is PaginationClass) {
          switch (_type) {
            case CommonStatePaginationType.pagedGridView:
              return PagedGridView<int, T>(
                shrinkWrap: shrinkWrap,
                pagingController: (state).pagingController as PagingController<int, T>,
                builderDelegate: PagedChildBuilderDelegate<T>(
                    itemBuilder: itemBuilder,
                    firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder != null
                        ? (context) => firstPageErrorIndicatorBuilder!
                        : null,
                    firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder != null
                        ? ((context) => firstPageProgressIndicatorBuilder!)
                        : null,
                    newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder != null
                        ? ((context) => newPageErrorIndicatorBuilder!)
                        : null,
                    newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder != null
                        ? ((context) => newPageProgressIndicatorBuilder!)
                        : null,
                    noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder != null
                        ? ((context) => noItemsFoundIndicatorBuilder!)
                        : null,
                    noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder != null
                        ? ((context) => noMoreItemsIndicatorBuilder!)
                        : null),
                gridDelegate: gridDelegate!,
              );
            case CommonStatePaginationType.pagedListView:
              return PagedListView<int, T>(
                padding: padding,
                scrollDirection: scrollDirection,
                physics: physics,
                pagingController: (state).pagingController as PagingController<int, T>,
                builderDelegate: PagedChildBuilderDelegate<T>(
                    itemBuilder: itemBuilder,
                    firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder != null
                        ? (context) => firstPageErrorIndicatorBuilder!
                        : null,
                    firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder != null
                        ? ((context) => firstPageProgressIndicatorBuilder!)
                        : null,
                    newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder != null
                        ? ((context) => newPageErrorIndicatorBuilder!)
                        : null,
                    newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder != null
                        ? ((context) => newPageProgressIndicatorBuilder!)
                        : null,
                    noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder != null
                        ? ((context) => noItemsFoundIndicatorBuilder!)
                        : null,
                    noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder != null
                        ? ((context) => noMoreItemsIndicatorBuilder!)
                        : null),
              );
            default:
              return PagedListView<int, T>(
                padding: padding,
                scrollDirection: scrollDirection,
                physics: physics,
                pagingController: (state).pagingController as PagingController<int, T>,
                builderDelegate: PagedChildBuilderDelegate<T>(
                    itemBuilder: itemBuilder,
                    firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder != null
                        ? (context) => firstPageErrorIndicatorBuilder!
                        : null,
                    firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder != null
                        ? ((context) => firstPageProgressIndicatorBuilder!)
                        : null,
                    newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder != null
                        ? ((context) => newPageErrorIndicatorBuilder!)
                        : null,
                    newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder != null
                        ? ((context) => newPageProgressIndicatorBuilder!)
                        : null,
                    noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder != null
                        ? ((context) => noItemsFoundIndicatorBuilder!)
                        : null,
                    noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder != null
                        ? ((context) => noMoreItemsIndicatorBuilder!)
                        : null),
              );
          }
        }
        return const SizedBox(child: Text("dsadas"));
      },
    );
  }
}
