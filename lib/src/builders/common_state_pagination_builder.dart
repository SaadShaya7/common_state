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

// [B] is the type of the bloc
// [T] is the type of the item
class CommonStatePaginationBuilder<B extends StateStreamable<StateObject>, T> extends StatefulWidget {
  const CommonStatePaginationBuilder.pagedListView({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    this.separatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
  })  : _type = CommonStatePaginationType.pagedListView,
        gridDelegate = null;

  const CommonStatePaginationBuilder.pagedGridView({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    required this.gridDelegate,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
  })  : _type = CommonStatePaginationType.pagedGridView,
        separatorBuilder = null;

  const CommonStatePaginationBuilder.pagedSliverList({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    this.separatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
  })  : _type = CommonStatePaginationType.pagedSliverList,
        gridDelegate = null;

  const CommonStatePaginationBuilder.pagedSliverGrid({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    required this.gridDelegate,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
  })  : _type = CommonStatePaginationType.pagedSliverGrid,
        separatorBuilder = null;

  const CommonStatePaginationBuilder.pagedPageView({
    super.key,
    required this.stateName,
    required this.builderDelegate,
    this.separatorBuilder,
    this.onPageKeyChanged,
    this.padding,
    this.scrollDirection,
    this.physics,
    this.shrinkWrap = false,
  })  : _type = CommonStatePaginationType.pagedPageView,
        gridDelegate = null;

  final String stateName;
  final CommonStatePaginationType _type;
  final CommonStatePagedChildBuilderDelegate<T> builderDelegate;

  final bool shrinkWrap;
  final Axis? scrollDirection;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final SliverGridDelegate? gridDelegate;
  final IndexedWidgetBuilder? separatorBuilder;
  final ValueChanged<int>? onPageKeyChanged;

  @override
  State<CommonStatePaginationBuilder<B, T>> createState() => _CommonStatePaginationBuilderState<B, T>();
}

class _CommonStatePaginationBuilderState<B extends StateStreamable<StateObject>, T>
    extends State<CommonStatePaginationBuilder<B, T>> {
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

    if (widget.onPageKeyChanged == null) return;

    final commonState = context.read<B>().state.getState(widget.stateName);

    if (commonState is! PaginationState) {
      throw Exception('${commonState.runtimeType} is not of type PaginationState');
    }

    final PaginationState paginationState = commonState;

    controller = paginationState.pagingController as PagingController<int, T>;

    controller.addPageRequestListener((pageKey) => widget.onPageKeyChanged!(pageKey));
  }

  Widget _buildPaginationWidget(CommonStatePaginationType type) {
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
      case CommonStatePaginationType.pagedGridView:
        return PagedGridView<int, T>(
          shrinkWrap: widget.shrinkWrap,
          pagingController: controller,
          builderDelegate: builderDelegate,
          gridDelegate: widget.gridDelegate!,
        );
      case CommonStatePaginationType.pagedListView:
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
      case CommonStatePaginationType.pagedSliverList:
        if (widget.separatorBuilder != null) {
          return PagedSliverList<int, T>.separated(
            separatorBuilder: widget.separatorBuilder!,
            pagingController: controller,
            builderDelegate: builderDelegate,
          );
        }
        return PagedSliverList<int, T>(pagingController: controller, builderDelegate: builderDelegate);
      case CommonStatePaginationType.pagedSliverGrid:
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
      builder: (context, state) => _buildPaginationWidget(widget._type),
    );
  }
}
