import 'package:common_state/common_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AppCommonStatePaginationBuilder<B extends StateStreamable<StateObject>, T> extends StatelessWidget {
  final String stateName;
  final CommonStatePaginationType _type;

  final ItemWidgetBuilder<T> itemBuilder;
  final Widget Function(dynamic)? firstPageErrorIndicatorBuilder;
  final Widget Function(dynamic)? newPageErrorIndicatorBuilder;
  final Widget? firstPageProgressIndicatorBuilder;
  final Widget? newPageProgressIndicatorBuilder;
  final Widget? noItemsFoundIndicatorBuilder;
  final Widget? noMoreItemsIndicatorBuilder;
  final EdgeInsetsGeometry? padding;
  final SliverGridDelegate? gridDelegate;

  final Axis? scrollDirection;

  final ScrollPhysics? physics;

  ///this is not required and when pass it null you should add paternalist in initState
  final ValueChanged<int>? onPageKeyChanged;
  final IndexedWidgetBuilder? separatorBuilder;

  const AppCommonStatePaginationBuilder.pagedListView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
    this.firstPageErrorIndicatorBuilder,
    this.separatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.padding,
    this.scrollDirection,
    this.physics,
    required this.onPageKeyChanged,
    this.gridDelegate,
  }) : _type = CommonStatePaginationType.pagedListView;

  const AppCommonStatePaginationBuilder.pagedGridView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
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
    this.gridDelegate,
  })  : _type = CommonStatePaginationType.pagedGridView,
        separatorBuilder = null;

  const AppCommonStatePaginationBuilder.pagedSliverListView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
    this.firstPageErrorIndicatorBuilder,
    this.separatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.padding,
    this.scrollDirection,
    this.physics,
    required this.onPageKeyChanged,
  })  : _type = CommonStatePaginationType.pagedSliverList,
        gridDelegate = null;

  const AppCommonStatePaginationBuilder.pagedSliverGridView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
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
    this.gridDelegate,
  })  : _type = CommonStatePaginationType.pagedSliverGrid,
        separatorBuilder = null;

  const AppCommonStatePaginationBuilder.pagedPageView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
    this.firstPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.separatorBuilder,
    this.padding,
    this.scrollDirection,
    this.physics,
    required this.onPageKeyChanged,
  })  : _type = CommonStatePaginationType.pagedPageView,
        gridDelegate = null;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case CommonStatePaginationType.pagedGridView:
        return CommonStatePaginationBuilder<B, T>.pagedGridView(
          stateName: stateName,
          itemBuilder: itemBuilder,
          firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder ?? (e) => Text(e),
          firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder ?? const Text('Loading'),
          newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder ?? (e) => Text(e),
          newPageProgressIndicatorBuilder:
              newPageProgressIndicatorBuilder ?? const CircularProgressIndicator(),
          noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder ?? const SizedBox.shrink(),
          noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder ?? const SizedBox.shrink(),
          gridDelegate: gridDelegate,
          onPageKeyChanged: onPageKeyChanged,
        );
      case CommonStatePaginationType.pagedListView:
        return CommonStatePaginationBuilder<B, T>.pagedListView(
          padding: padding,
          physics: physics,
          scrollDirection: scrollDirection ?? Axis.vertical,
          separatorBuilder: separatorBuilder,
          stateName: stateName,
          itemBuilder: itemBuilder,
          firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder ?? (e) => Text(e),
          firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder ?? const Text('Loading'),
          newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder ?? (e) => Text(e),
          newPageProgressIndicatorBuilder:
              newPageProgressIndicatorBuilder ?? const CircularProgressIndicator(),
          noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder ?? const SizedBox.shrink(),
          noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder ?? const SizedBox.shrink(),
          onPageKeyChanged: onPageKeyChanged,
        );
      case CommonStatePaginationType.pagedSliverList:
        return CommonStatePaginationBuilder<B, T>.pagedSliverList(
          separatorBuilder: separatorBuilder,
          stateName: stateName,
          itemBuilder: itemBuilder,
          firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder ?? (e) => Text(e),
          firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder ?? const Text('Loading'),
          newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder ?? (e) => Text(e),
          newPageProgressIndicatorBuilder:
              newPageProgressIndicatorBuilder ?? const CircularProgressIndicator(),
          noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder ?? const SizedBox.shrink(),
          noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder ?? const SizedBox.shrink(),
          onPageKeyChanged: onPageKeyChanged,
        );
      case CommonStatePaginationType.pagedSliverGrid:
        return CommonStatePaginationBuilder<B, T>.pagedSliverGrid(
          stateName: stateName,
          itemBuilder: itemBuilder,
          firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder ?? (e) => Text(e),
          firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder ?? const Text('Loading'),
          newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder ?? (e) => Text(e),
          newPageProgressIndicatorBuilder:
              newPageProgressIndicatorBuilder ?? const CircularProgressIndicator(),
          noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder ?? const SizedBox.shrink(),
          noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder ?? const SizedBox.shrink(),
          gridDelegate: gridDelegate,
          onPageKeyChanged: onPageKeyChanged,
        );
      case CommonStatePaginationType.pagedPageView:
        return CommonStatePaginationBuilder<B, T>.pagedPageView(
          separatorBuilder: separatorBuilder,
          stateName: stateName,
          itemBuilder: itemBuilder,
          firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder ?? (e) => Text(e),
          firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder ?? const Text('Loading'),
          newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder ?? (e) => Text(e),
          newPageProgressIndicatorBuilder:
              newPageProgressIndicatorBuilder ?? const CircularProgressIndicator(),
          noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder ?? const SizedBox.shrink(),
          noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder ?? const SizedBox.shrink(),
          onPageKeyChanged: onPageKeyChanged,
        );
      default:
        return const SizedBox();
    }
  }
}
