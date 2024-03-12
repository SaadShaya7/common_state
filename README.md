# Common State 🔮

Common State is a Flutter package designed to simplify state management in Flutter applications, especially when working with the [flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc) package. It aims to automate state control, emitting the appropriate state (success, failure, loading, etc.) based on the application's data flow.

## Features

- **Automatic State Management**: Automatically handles state transitions, including success, failure, and loading states.
- **Pagination Support**: Built-in support for paginated data handling.
- **Customizable Error Handling**: Allows for custom error types to be defined and handled.
- **Integration with flutter_bloc**: Designed to work seamlessly with the flutter_bloc package, but can also be used with Cubit.

## Getting Started

### 1. Define Your State Types

First, define your own state types to work with the Common State package. This includes defining your error type (optional) and creating aliases for the various state types you'll be using.

```dart
typedef AppStates = States<CustomErrorType>; // Map<String,CommonState<dynamic,CustomErrorType>>

typedef AppCommonState<T> = CommonState<T, CustomErrorType>;

typedef Success<T> = SuccessState<T, CustomErrorType>;
typedef Loading<T> = LoadingState<T, CustomErrorType>;
typedef Failure<T> = FailureState<T, CustomErrorType>;
typedef Empty<T> = EmptyState<T, CustomErrorType>;
typedef Initial<T> = InitialState<T, CustomErrorType>;
```

### 2. Define Your State Class

Create a state class that extends `StateObject`. This class will manage your application's states.

```dart
class ExampleState extends StateObject<ExampleState> {
 static const String state1 = 'getData';
 static const String state2 = 'postData';
 static const String state3 = 'getPaginatedData';

 ExampleState([States? states])
      : super(
          [
            const Initial<String>(state1),
            const Initial<bool>(state2),
            PaginationState<PaginationModel<String>>(state3)
          ],
          (states) => ExampleState(states),
          states,
        );
}
```

### 3. Define Your Events

Define events that your Bloc or Cubit will handle. These events represent the different actions that can be performed in your application.

```dart
abstract class ExampleEvent {}

class Fetch extends ExampleEvent {
 const Fetch();
}

class Post extends ExampleEvent {
 const Post();
}

class FetchPaginated extends ExampleEvent {
 final int pageKey;
 const FetchPaginated(this.pageKey);
}
```

### 4. Define Your Bloc or Cubit

In your Bloc or Cubit, use the provided methods to handle API calls and paginated data fetching.

```dart
class MultiStateBloc extends Bloc<CommonStateEvent, MultiStateBlocState> {
 MultiStateBloc() : super(MultiStateBlocState()) {
    multiStateApiCall<Fetch, String>(ExampleState.state1, (event) => getSomeDataUseCase());
    multiStateApiCall<Post, bool>(ExampleState.state2, (event) => postSomeDataUseCase());
    multiStatePaginatedApiCall<FetchPaginated,String>(ExampleState.state3, (event) => someUseCase(), (event) => event.pageKey);
 }
}
```

### 5. Use Builders in Your UI

Utilize the provided builders to easily manage UI based on the state of your application.

- `ResultBuilder`: For a Cubit with a single CommonState.
- `CommonStateBuilder`: For a Bloc/Cubit with multiple CommonState instances.
- `CommonStatePaginatedBuilder`: For a Bloc/Cubit with multiple CommonState instances for paginated data.

## Additional Considerations

- **PaginationModel<T>**: Use `PaginationModel<T>` as your pagination model. If your pagination model is nested, inherit from `PaginatedModel<T>` and override the `getPaginatedDataMethod`.

## Example

For a complete usage example, refer to the [Example App](https://gitlab.com/humynewversion/common_state/-/tree/main/example?ref_type=heads).

## Conclusion

Common State is designed to make state management in Flutter applications easier and more efficient. Whether you're working with simple states or complex paginated data, Common State provides the tools you need to manage it all.

*Happy Coding ⭐*