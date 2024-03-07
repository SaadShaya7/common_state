
# Usage



## 1-   Define app overrides
We Do not know what your error type is so we designed functions and widgets so you can override them


```

// Supposing this is your Error case class
class CustomErrorType {
  final String error;
  CustomErrorType(this.error);
}

```

 Define the sates you want to use in your app, \ that step is needed to define your error type without having to specify it every time

```

typedef AppCommonState<T> = CommonState<T, CustomErrorType>;
typedef Success<T> = SuccessState<T, CustomErrorType>;
typedef Loading<T> = LoadingState<T, CustomErrorType>;
typedef Error<T> = ErrorState<T, CustomErrorType>;
typedef Empty<T> = EmptyState<T, CustomErrorType>;
typedef Initial<T> = InitialState<T, CustomErrorType>;
typedef AppStates = States<CustomErrorType>;


```

 then define app widgets that call our widgets with specifying the error type too
```
class AppCommonStateBuilder<B extends StateStreamable<Map<int, AppCommonState<T>>>, T>
    extends StatelessWidget {
  final int index;
  final Widget Function(T data) onSuccess;

  final Widget onLoading;
  final Widget onInit;
  final Widget onEmpty;
  final Widget Function(CustomErrorType exception) onError;

  const AppCommonStateBuilder({
    super.key,
    required this.index,
    required this.onSuccess,
    required this.onInit,
    required this.onEmpty,
    required this.onError,
    required this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CommonStateBuilder<B, T, CustomErrorType>(
      index: index,
      onSuccess: onSuccess,
      onLoading: onLoading,
      onInit: onInit,
      onEmpty: onEmpty,
      onError: onError,
    );
  }
}


// this one to handel pagination

class AppCommonStatePaginationBuilder<B extends StateStreamable<Map<int, AppCommonState<T>>>, T>
    extends StatefulWidget {
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

class _AppCommonStatePaginationBuilderState<B extends StateStreamable<Map<int, AppCommonState<T>>>, T>
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

```

## 2- Start to Implement your first bloc with common state
 Define the your state object as below they should all be static members
```
class CommonStateExample {
  // Those will act as map keys for your state objects
  static int state1 = 0;
  static int state2 = 1;
  static int state3 = 2;
  static int state4 = 3;

  static Map<int, AppCommonState> init = {
    state1: const Initial<String>(),
    state2: const Initial<int>(),
    state3: const Initial<double>(),
    state4: const Initial<void>(),
  };
}


//supposing this is your event class
class CommonStateExampleEvent {}

```
And your bloc now will look like this
```
class CommonStateBlocExample extends Bloc<CommonStateExampleEvent, Map<int, AppCommonState>> {
  CommonStateBlocExample() : super(CommonStateExample.init) {
    on<CommonStateExampleEvent>(
      (event, emit) => StateHandlers.handelMultiApiResult(
        callback: () async => const Right("Success"),
        emit: emit,
        state: state,
        index: CommonStateExample.state1,
      ),
    );
  }
}

```


## 3- finally in your UI just call the commonStateBuilder or the CommonStatePaginationBuilder depending on your use case
 just Add your bloc provider and you're good to go \
 There is no need to call bloc builder we did it for you 😁
```
class CommonStateUiExample extends StatelessWidget {
  const CommonStateUiExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommonStateBlocExample(),
      child: AppCommonStateBuilder<CommonStateBlocExample, int>(
        index: CommonStateExample.state1,
        onSuccess: (data) => const Placeholder(),
        onLoading: const Placeholder(),
        onInit: const Placeholder(),
        onEmpty: const Placeholder(),
        onError: (e) => const Placeholder(),
      ),
    );
  }
}
```

