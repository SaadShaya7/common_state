import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../state/common_state.dart';

/// B is Bloc
/// T is Enum and should extends from Helper
/// E is Error type
class CommonStatePaginationBuilder<B extends StateStreamable<Map<int, CommonState>>, T, E>
    extends StatefulWidget {
  const CommonStatePaginationBuilder({
    super.key,
    required this.index,
    required this.itemBuilder,
    required this.firstPageErrorIndicatorBuilder,
    required this.firstPageProgressIndicatorBuilder,
    required this.newPageErrorIndicatorBuilder,
    required this.newPageProgressIndicatorBuilder,
    required this.noItemsFoundIndicatorBuilder,
    required this.noMoreItemsIndicatorBuilder,
    required this.pageListenerCallback,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.physics,
  });

  final int index;
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
  final ValueChanged<int> pageListenerCallback;

  @override
  State<CommonStatePaginationBuilder> createState() => _CommonStatePaginationBuilderState();
}

class _CommonStatePaginationBuilderState<B extends StateStreamable<Map<int, CommonState>>, T, E>
    extends State<CommonStatePaginationBuilder> {
  @override
  void initState() {
    (context.read<B>().state[widget.index] as PaginationClass<T, E>)
        .pagingController
        .addPageRequestListener((pageKey) {
      widget.pageListenerCallback(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, Map<int, CommonState>, CommonState<T, E>>(
      selector: (state) => state[widget.index] as CommonState<T, E>,
      builder: (context, state) {
        if (state is PaginationClass) {
          return PagedListView<int, T>(
            padding: widget.padding,
            scrollDirection: widget.scrollDirection,
            physics: widget.physics,
            pagingController: (state as PaginationClass<int, T>).pagingController as PagingController<int, T>,
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
                  : null,
            ),
          );
        }
        return const SizedBox(child: Text("place holder"));
      },
    );
  }
}
