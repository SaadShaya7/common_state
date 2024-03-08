import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../common_state.dart';

extension StateUtils<T, E> on CommonState<T, E> {
  bool get isInitial => this is InitialState;

  bool get isLoading => this is LoadingState;

  bool get isError => this is ErrorState;

  bool get isSuccess => this is SuccessState;

  bool get isEmpty => this is EmptyState;

  E? get error {
    if (this is ErrorState) return (this as ErrorState).error;
    return null;
  }

  T? get data {
    if (this is SuccessState) return this.data;
    return null;
  }

  SuccessState<T, E> updateSuccessState(T updatedData) {
    if (this is! SuccessState) throw Exception('$runtimeType is not SuccessState');

    return SuccessState<T, E>(updatedData);
  }

  void refreshPagingController() {
    if (this is! PaginationState) throw Exception('$runtimeType is not PaginationState');

    final pagingController = (this as PaginationState).pagingController;

    pagingController.refresh();
  }

  PagingController<int, T> pagingController() {
    if (this is! PaginationState) throw Exception('$runtimeType is not PaginationState');

    return (this as PaginationState<T>).pagingController;
  }
}
