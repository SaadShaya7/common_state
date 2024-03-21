import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum PagedWidgetType { pagedListView, pagedGridView, pagedSliverList, pagedSliverGrid, pagedPageView }

// [B] is the type of the bloc
// [T] is the type of the item
class PagedBuilder<B extends StateStreamable<StateObject>, T> extends StatefulWidget {
  const PagedBuilder.pagedListView({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    this.separatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
    this.prepare,
    this.successWrapper,
  })  : _type = PagedWidgetType.pagedListView,
        gridDelegate = null;

  const PagedBuilder.pagedGridView({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    required this.gridDelegate,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
    this.prepare,
    this.successWrapper,
  })  : _type = PagedWidgetType.pagedGridView,
        separatorBuilder = null;

  const PagedBuilder.pagedSliverList({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    this.separatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
    this.prepare,
    this.successWrapper,
  })  : _type = PagedWidgetType.pagedSliverList,
        gridDelegate = null;

  const PagedBuilder.pagedSliverGrid({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    required this.gridDelegate,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
    this.prepare,
    this.successWrapper,
  })  : _type = PagedWidgetType.pagedSliverGrid,
        separatorBuilder = null;

  const PagedBuilder.pagedPageView({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    this.separatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
    this.prepare,
    this.successWrapper,
  })  : _type = PagedWidgetType.pagedPageView,
        gridDelegate = null;

  final String stateName;
  final PagedWidgetType _type;
  final PagedBuilderDelegate<T> builderDelegate;

  final bool shrinkWrap;
  final Axis? scrollDirection;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final SliverGridDelegate? gridDelegate;
  final IndexedWidgetBuilder? separatorBuilder;
  final ValueChanged<int>? onPageKeyChanged;
  final void Function(PagingController<int, T> controller)? prepare;
  final Widget Function(Widget pagedWidget)? successWrapper;

  @override
  State<PagedBuilder<B, T>> createState() => _PagedBuilderState<B, T>();
}

class _PagedBuilderState<B extends StateStreamable<StateObject>, T> extends State<PagedBuilder<B, T>> {
  late final PagingController<int, T> controller;

  PaginationState _stateSelector(StateObject state) {
    final selectedState = state.getState(widget.stateName);

    if (selectedState is! PaginationState) {
      throw Exception(
        ''' The selected state (${widget.stateName}) is not a PaginationState of the required type  '''
        '''${state.runtimeType} is not of type PaginationState''',
      );
    }

    return selectedState;
  }

  @override
  void initState() {
    super.initState();

    final commonState = context.read<B>().state.getState(widget.stateName);

    if (commonState is! PaginationState) {
      throw Exception('${commonState.runtimeType} is not of type PaginationState');
    }

    final PaginationState paginationState = commonState;

    controller = paginationState.pagingController as PagingController<int, T>;

    widget.prepare?.call(controller);

    if (widget.onPageKeyChanged == null) return;

    controller.addPageRequestListener((pageKey) => widget.onPageKeyChanged!(pageKey));
  }

  Widget _buildPaginationWidget(PagedWidgetType type) {
    final builderDelegate = PagedChildBuilderDelegate<T>(
      itemBuilder: widget.builderDelegate.itemBuilder,
      firstPageErrorIndicatorBuilder: (context) =>
          widget.builderDelegate.firstPageErrorIndicatorBuilder(controller.error),
      firstPageProgressIndicatorBuilder: (context) =>
          widget.builderDelegate.firstPageProgressIndicatorBuilder,
      newPageErrorIndicatorBuilder: (context) =>
          widget.builderDelegate.newPageErrorIndicatorBuilder(controller.error),
      newPageProgressIndicatorBuilder: (context) => widget.builderDelegate.newPageProgressIndicatorBuilder,
      noItemsFoundIndicatorBuilder: (context) => widget.builderDelegate.noItemsFoundIndicatorBuilder,
      noMoreItemsIndicatorBuilder: (context) => widget.builderDelegate.noMoreItemsIndicatorBuilder,
    );

    switch (type) {
      case PagedWidgetType.pagedGridView:
        return PagedGridView<int, T>(
          shrinkWrap: widget.shrinkWrap,
          pagingController: controller,
          builderDelegate: builderDelegate,
          gridDelegate: widget.gridDelegate!,
        );
      case PagedWidgetType.pagedListView:
        if (widget.separatorBuilder != null) {
          return PagedListView<int, T>.separated(
            separatorBuilder: widget.separatorBuilder!,
            padding: widget.padding,
            scrollDirection: widget.scrollDirection ?? Axis.vertical,
            physics: widget.physics,
            pagingController: controller,
            builderDelegate: builderDelegate,
          );
        }
        return PagedListView<int, T>(
          padding: widget.padding,
          scrollDirection: widget.scrollDirection ?? Axis.vertical,
          physics: widget.physics,
          pagingController: controller,
          builderDelegate: builderDelegate,
        );
      case PagedWidgetType.pagedSliverList:
        if (widget.separatorBuilder != null) {
          return PagedSliverList<int, T>.separated(
            separatorBuilder: widget.separatorBuilder!,
            pagingController: controller,
            builderDelegate: builderDelegate,
          );
        }
        return PagedSliverList<int, T>(pagingController: controller, builderDelegate: builderDelegate);
      case PagedWidgetType.pagedSliverGrid:
        return PagedSliverGrid<int, T>(
          pagingController: controller,
          builderDelegate: builderDelegate,
          gridDelegate: widget.gridDelegate!,
        );
      default:
        throw Exception('Unsupported pagination type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, StateObject, PaginationState>(
      selector: _stateSelector,
      builder: (context, state) {
        final pagedBuilder = _buildPaginationWidget(widget._type);
        if ((state.pagingController.itemList?.isEmpty ?? true) || widget.successWrapper == null) {
          return pagedBuilder;
        }
        return widget.successWrapper!(pagedBuilder);
      },
    );
  }
}
