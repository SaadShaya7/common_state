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
  final bool? shrinkWrap;

  ///this is not required and when pass it null you should add paternalist in initState
  final ValueChanged<int>? onPageKeyChanged;
  final IndexedWidgetBuilder? separatorBuilder;

  const AppCommonStatePaginationBuilder.pagedListView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
    required this.onPageKeyChanged,
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
    this.gridDelegate,
    this.shrinkWrap,
  }) : _type = CommonStatePaginationType.pagedListView;

  const AppCommonStatePaginationBuilder.pagedGridView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
    required this.onPageKeyChanged,
    this.firstPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.gridDelegate,
    this.shrinkWrap,
  })  : _type = CommonStatePaginationType.pagedGridView,
        separatorBuilder = null;

  const AppCommonStatePaginationBuilder.pagedSliverListView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
    required this.onPageKeyChanged,
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
    this.shrinkWrap,
  })  : _type = CommonStatePaginationType.pagedSliverList,
        gridDelegate = null;

  const AppCommonStatePaginationBuilder.pagedSliverGridView({
    super.key,
    required this.itemBuilder,
    required this.stateName,
    required this.onPageKeyChanged,
    this.firstPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.gridDelegate,
    this.shrinkWrap,
  })  : _type = CommonStatePaginationType.pagedSliverGrid,
        separatorBuilder = null;

  const AppCommonStatePaginationBuilder.pagedPageView({
    super.key,
    required this.onPageKeyChanged,
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
    this.shrinkWrap,
  })  : _type = CommonStatePaginationType.pagedPageView,
        gridDelegate = null;

  Widget _buildPaginationWidget(CommonStatePaginationType type) {
    final commonStateBuilderDelegate = CommonStatePagedChildBuilderDelegate<T>(
      itemBuilder: itemBuilder,
      firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder ?? (error) => Text(error),
      firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder ?? const Text('Loading'),
      newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder ?? (error) => Text(error),
      newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder ?? const Text('loading'),
      noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder ?? const Text('no items'),
      noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder ?? const Text('not items'),
    );

    switch (type) {
      case CommonStatePaginationType.pagedGridView:
        return CommonStatePaginationBuilder.pagedGridView(
          stateName: stateName,
          gridDelegate: gridDelegate,
          builderDelegate: commonStateBuilderDelegate,
          onPageKeyChanged: onPageKeyChanged,
          padding: padding,
          physics: physics,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap ?? false,
        );
      case CommonStatePaginationType.pagedListView:
        if (separatorBuilder != null) {
          return CommonStatePaginationBuilder.pagedListView(
            separatorBuilder: separatorBuilder!,
            stateName: stateName,
            padding: padding,
            physics: physics,
            builderDelegate: commonStateBuilderDelegate,
            onPageKeyChanged: onPageKeyChanged,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap ?? false,
          );
        }
        return CommonStatePaginationBuilder.pagedListView(
          padding: padding,
          stateName: stateName,
          physics: physics,
          builderDelegate: commonStateBuilderDelegate,
          onPageKeyChanged: onPageKeyChanged,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap ?? false,
        );
      case CommonStatePaginationType.pagedSliverList:
        if (separatorBuilder != null) {
          return CommonStatePaginationBuilder.pagedSliverList(
            stateName: stateName,
            separatorBuilder: separatorBuilder!,
            builderDelegate: commonStateBuilderDelegate,
            onPageKeyChanged: onPageKeyChanged,
            padding: padding,
            physics: physics,
            scrollDirection: scrollDirection,
            shrinkWrap: shrinkWrap ?? false,
          );
        }
        return CommonStatePaginationBuilder.pagedSliverList(
          stateName: stateName,
          builderDelegate: commonStateBuilderDelegate,
          shrinkWrap: shrinkWrap ?? false,
        );
      case CommonStatePaginationType.pagedSliverGrid:
        return CommonStatePaginationBuilder.pagedSliverGrid(
          stateName: stateName,
          onPageKeyChanged: onPageKeyChanged,
          padding: padding,
          physics: physics,
          scrollDirection: scrollDirection,
          builderDelegate: commonStateBuilderDelegate,
          gridDelegate: gridDelegate!,
          shrinkWrap: shrinkWrap ?? false,
        );
      default:
        throw Exception('Unsupported pagination type');
    }
  }

  @override
  Widget build(BuildContext context) => _buildPaginationWidget(_type);
}
