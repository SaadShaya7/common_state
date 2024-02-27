import 'package:common_state/common_state.dart';
import 'package:example/common_state_overrides/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AppCommonStatePaginationBuilder<B extends StateStreamable<States>, T> extends StatefulWidget {
  final int index;
  final bool idGridView;
  final bool shrinkWrap;

  final ItemWidgetBuilder<T> itemBuilder;
  final Widget? firstPageErrorIndicatorBuilder;
  final Widget? firstPageProgressIndicatorBuilder;
  final Widget? newPageErrorIndicatorBuilder;
  final Widget? newPageProgressIndicatorBuilder;
  final Widget? noItemsFoundIndicatorBuilder;
  final Widget? noMoreItemsIndicatorBuilder;
  final EdgeInsetsGeometry? padding;

  final Axis? scrollDirection;

  final ScrollPhysics? physics;
  final ValueChanged<int> onPageKeyChanged;

  const AppCommonStatePaginationBuilder.pagedListView({
    super.key,
    required this.itemBuilder,
    required this.index,
    this.firstPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.padding,
    this.scrollDirection,
    this.physics,
    required this.onPageKeyChanged,
    this.shrinkWrap = false,
  }) : idGridView = false;

  const AppCommonStatePaginationBuilder.pagedGridView({
    super.key,
    required this.itemBuilder,
    required this.index,
    this.firstPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.padding,
    this.scrollDirection,
    this.physics,
    required this.onPageKeyChanged,
    this.shrinkWrap = false,
  }) : idGridView = true;

  @override
  State<AppCommonStatePaginationBuilder<B, T>> createState() => _AppCommonStatePaginationBuilderState<B, T>();
}

class _AppCommonStatePaginationBuilderState<B extends StateStreamable<States>, T>
    extends State<AppCommonStatePaginationBuilder<B, T>> {
  @override
  void initState() {
    (context.read<B>().state[widget.index] as Pagination<T>)
        .pagingController
        .addPageRequestListener((pageKey) {
      widget.onPageKeyChanged(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.idGridView) {
      return CommonStatePaginationBuilder<B, T>.pagedGridView(
        index: widget.index,
        itemBuilder: widget.itemBuilder,
        firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder,
        firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder,
        newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
        newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder,
        noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder,
        noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder,
        shrinkWrap: widget.shrinkWrap,
      );
    } else {
      return CommonStatePaginationBuilder<B, T>.pagedListView(
        index: widget.index,
        itemBuilder: widget.itemBuilder,
        firstPageErrorIndicatorBuilder: widget.firstPageErrorIndicatorBuilder,
        firstPageProgressIndicatorBuilder: widget.firstPageProgressIndicatorBuilder,
        newPageErrorIndicatorBuilder: widget.newPageErrorIndicatorBuilder,
        newPageProgressIndicatorBuilder: widget.newPageProgressIndicatorBuilder,
        noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder,
        noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder,
        shrinkWrap: widget.shrinkWrap,
      );
    }
  }
}
