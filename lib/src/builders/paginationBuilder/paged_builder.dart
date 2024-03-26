import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum PagedWidgetType { pagedListView, pagedGridView, pagedSliverList, pagedSliverGrid, pagedPageView }

// [B] is the type of the bloc
// [T] is the type of the item
class PagedBuilder<B extends StateStreamable<BaseState>, T> extends StatefulWidget {
  const PagedBuilder.pagedListView({
    super.key,
    required this.builderDelegate,
    this.stateName,
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
    required this.builderDelegate,
    required this.gridDelegate,
    this.stateName,
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
    required this.builderDelegate,
    this.stateName,
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
    required this.builderDelegate,
    required this.gridDelegate,
    this.stateName,
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
    required this.builderDelegate,
    this.stateName,
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

  final PagedWidgetType _type;
  final PagedBuilderDelegate<T> builderDelegate;

  final String? stateName;
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

class _PagedBuilderState<B extends StateStreamable<BaseState>, T> extends State<PagedBuilder<B, T>> {
  late final PagingController<int, T> controller;
  bool _firstPageLoaded = false;

  PaginationState _stateSelector(BaseState state) {
    if (state is! StateObject) {
      if (state is PaginationState) return state;

      throw UnsupportedError('The state is neither a StateObject nor a PaginationState');
    }

    if (widget.stateName == null) {
      throw ArgumentError('The state is of type StateObject but the stateName was not provided');
    }

    final selectedState = state.getState(widget.stateName!);

    if (selectedState is! PaginationState) {
      throw UnsupportedError(
        ''' The selected state (${widget.stateName}) is not a PaginationState of the required type  '''
        '''${state.runtimeType} is not of type PaginationState''',
      );
    }

    return selectedState;
  }

  @override
  void initState() {
    super.initState();

    final PaginationState state = _stateSelector(context.read<B>().state);

    controller = state.pagingController as PagingController<int, T>;

    widget.prepare?.call(controller);

    if (widget.successWrapper != null) {
      controller.addStatusListener((status) {
        if (status == PagingStatus.ongoing && !_firstPageLoaded) {
          setState(() => _firstPageLoaded = true);
        }
      });
    }
    if (widget.onPageKeyChanged != null) {
      controller.addPageRequestListener((pageKey) => widget.onPageKeyChanged!(pageKey));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
        return PagedSliverList<int, T>(
          pagingController: controller,
          builderDelegate: builderDelegate,
        );
      case PagedWidgetType.pagedSliverGrid:
        return PagedSliverGrid<int, T>(
          pagingController: controller,
          builderDelegate: builderDelegate,
          gridDelegate: widget.gridDelegate!,
        );
      default:
        throw UnsupportedError('Unsupported pagination type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, BaseState, PaginationState>(
      selector: _stateSelector,
      builder: (context, state) {
        final pagedBuilder = _buildPaginationWidget(widget._type);
        if (_showSuccessWrapper) {
          return widget.successWrapper!(pagedBuilder);
        }
        return pagedBuilder;
      },
    );
  }

  bool get _showSuccessWrapper => _isFirstPage && widget.successWrapper != null;

  bool get _isFirstPage => controller.nextPageKey == controller.firstPageKey + 1;
}
