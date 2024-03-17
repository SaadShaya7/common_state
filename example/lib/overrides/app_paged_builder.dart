import 'package:common_state/common_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AppPagedBuilder<B extends StateStreamable<StateObject>, T> extends StatelessWidget {
  final String stateName;
  final PagedWidgetType _type;

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

  const AppPagedBuilder.pagedListView({
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
  }) : _type = PagedWidgetType.pagedListView;

  const AppPagedBuilder.pagedGridView({
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
  })  : _type = PagedWidgetType.pagedGridView,
        separatorBuilder = null;

  const AppPagedBuilder.pagedSliverListView({
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
  })  : _type = PagedWidgetType.pagedSliverList,
        gridDelegate = null;

  const AppPagedBuilder.pagedSliverGridView({
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
  })  : _type = PagedWidgetType.pagedSliverGrid,
        separatorBuilder = null;

  const AppPagedBuilder.pagedPageView({
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
  })  : _type = PagedWidgetType.pagedPageView,
        gridDelegate = null;

  Widget _buildPaginationWidget(PagedWidgetType type) {
    final commonStateBuilderDelegate = PagedBuilderDelegate<T>(
      itemBuilder: itemBuilder,
      firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder ??
          (error) => Center(
                  child: Text(
                error,
                style: const TextStyle(fontSize: 30),
              )),
      firstPageProgressIndicatorBuilder: Center(
          child: firstPageProgressIndicatorBuilder ??
              const Text(
                'Loading',
                style: TextStyle(fontSize: 30),
              )),
      newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder ??
          (error) => Center(
                  child: Text(
                error,
                style: const TextStyle(fontSize: 30),
              )),
      newPageProgressIndicatorBuilder: Center(
          child: newPageProgressIndicatorBuilder ?? const Text('loading', style: TextStyle(fontSize: 30))),
      noItemsFoundIndicatorBuilder: Center(
          child: noItemsFoundIndicatorBuilder ??
              const Text(
                'no items',
                style: TextStyle(fontSize: 30),
              )),
      noMoreItemsIndicatorBuilder: Center(
          child: noMoreItemsIndicatorBuilder ??
              const Text(
                'not items',
                style: TextStyle(fontSize: 30),
              )),
    );

    switch (type) {
      case PagedWidgetType.pagedGridView:
        return PagedBuilder<B, T>.pagedGridView(
          stateName: stateName,
          gridDelegate: gridDelegate,
          builderDelegate: commonStateBuilderDelegate,
          onPageKeyChanged: onPageKeyChanged,
          padding: padding,
          physics: physics,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap ?? false,
        );
      case PagedWidgetType.pagedListView:
        if (separatorBuilder != null) {
          return PagedBuilder<B, T>.pagedListView(
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
        return PagedBuilder<B, T>.pagedListView(
          padding: padding,
          stateName: stateName,
          physics: physics,
          builderDelegate: commonStateBuilderDelegate,
          onPageKeyChanged: onPageKeyChanged,
          scrollDirection: scrollDirection,
          shrinkWrap: shrinkWrap ?? false,
        );
      case PagedWidgetType.pagedSliverList:
        if (separatorBuilder != null) {
          return PagedBuilder<B, T>.pagedSliverList(
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
        return PagedBuilder<B, T>.pagedSliverList(
          stateName: stateName,
          builderDelegate: commonStateBuilderDelegate,
          shrinkWrap: shrinkWrap ?? false,
        );
      case PagedWidgetType.pagedSliverGrid:
        return PagedBuilder<B, T>.pagedSliverGrid(
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
