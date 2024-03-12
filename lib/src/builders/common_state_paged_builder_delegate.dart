import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// A Custom delegate that substitute the original [PagedChildBuilderDelegate]
class CommonStatePagedChildBuilderDelegate<ItemType> {
  CommonStatePagedChildBuilderDelegate({
    required this.itemBuilder,
    required this.firstPageErrorIndicatorBuilder,
    required this.newPageErrorIndicatorBuilder,
    required this.firstPageProgressIndicatorBuilder,
    required this.newPageProgressIndicatorBuilder,
    required this.noItemsFoundIndicatorBuilder,
    required this.noMoreItemsIndicatorBuilder,
    this.animateTransitions = false,
    this.transitionDuration = const Duration(milliseconds: 250),
  });

  final ItemWidgetBuilder<ItemType> itemBuilder;
  final Widget Function(dynamic error) firstPageErrorIndicatorBuilder;
  final Widget Function(dynamic error) newPageErrorIndicatorBuilder;
  final Widget firstPageProgressIndicatorBuilder;
  final Widget newPageProgressIndicatorBuilder;
  final Widget noItemsFoundIndicatorBuilder;
  final Widget noMoreItemsIndicatorBuilder;
  final bool animateTransitions;
  final Duration transitionDuration;
}
