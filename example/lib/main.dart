import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

///*------------------------------------------------------------------------------------------------- STEP 1
///* Defining app overrides
///* We Do not know what your error type is so we designed functions and widgets so you can override them

// Supposing this is your Error case class
class CustomErrorType {
  final String error;
  CustomErrorType(this.error);
}

// Define Common state in your app for specifying error type
typedef AppCommonState<T> = CommonState<T, CustomErrorType>;

// then define app widgets that call our widgets with specifying the error type too
class AppCommonStateBuilder<B extends StateStreamable<Map<int, CommonState>>, T> extends StatelessWidget {
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
class AppCommonStatePaginationBuilder<B extends StateStreamable<Map<int, CommonState>>, T>
    extends StatelessWidget {
  final int index;

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
  final ValueChanged<int> pageListenerCallback;

  const AppCommonStatePaginationBuilder({
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
    required this.pageListenerCallback,
  });

  @override
  Widget build(BuildContext context) {
    return CommonStatePaginationBuilder<B, T, CustomErrorType>(
      index: index,
      itemBuilder: itemBuilder,
      firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder,
      firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder,
      newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder,
      newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder,
      noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder,
      noMoreItemsIndicatorBuilder: noMoreItemsIndicatorBuilder,
      pageListenerCallback: pageListenerCallback,
    );
  }
}

//
//
//
//
//
//
//
//
//
//
//
//
//

///*------------------------------------------------------------------------------------------------- STEP 2
///* Starting to Implement your first bloc
///* Define the your state object as below they should all be static members

class CommonStateExample {
  // Those will act as map keys for your state objects
  static int state1 = 0;
  static int state2 = 1;
  static int state3 = 2;
  static int state4 = 3;

  static Map<int, AppCommonState> init = {
    state1: const InitialState<String, CustomErrorType>(),
    state2: const InitialState<int, CustomErrorType>(),
    state3: const InitialState<double, CustomErrorType>(),
    state4: const InitialState<void, CustomErrorType>(),
  };
}

//supposing this is your event class
class CommonStateExampleEvent {}

class CommonStateBlocExample extends Bloc<CommonStateExampleEvent, Map<int, CommonState>> {
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

//
//
//
//
//
//
//
//
//
//
//
//
//

///*------------------------------------------------------------------------------------------------- STEP 3
///* finally in your UI just call the commonStateBuilder or the CommonStatePaginationBuilder depending on your use case
///* There is no need to call bloc builder we did it for you ;)

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
