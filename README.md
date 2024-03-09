# Common state 🔮
A Flutter package that facilitates working with [flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc) package, Making it easier to deal with states and api Calls.

# Usage

##  The very first thing you have to do is defining your own types, in order to pass us your  error type
supposing your ErrorType is defined as CustomErrorType
```dart

typedef AppStates = States<CustomErrorType>; // this one is simply Map<String,CommonState<dynamic,CustomErrorType>>

typedef AppCommonState<T> = CommonState<T, CustomErrorType>;

typedef Success<T> = SuccessState<T, CustomErrorType>;
typedef Loading<T> = LoadingState<T, CustomErrorType>;
typedef Failure<T> = FailureState<T, CustomErrorType>;
typedef Empty<T> = EmptyState<T, CustomErrorType>;
typedef Initial<T> = InitialState<T, CustomErrorType>;

```
After applying this step you won't need to pass your error type as generic every time you are going to pass a new state, just use your predefined types.


# Example

### Supposing we have to fetch data from api, one paginated and one not, and post some other here is the steps we have to go through, 
This example will use BLoc as an option, feel free to use cubit, you will find the same methods waiting for you...

### 1. Define your state
Your state must inherit **StateObject** class, and must be used as the following:
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
            PaginationState<String>(state3)
          ],
          (states) => ExampleState(states),
          states,
        );
}
```
Please take to notice the following things:
-  that **States** must be provided as a positioned Optional parameter in your object constructor.
-  Your states, will be added as a list to the super constructor, the state name is passed to each state
-  Pagination states will be added to the list and will be handled respectivly.
### 2. Define your Events
You will not find anything new in this step, it's just how it's usually done in the flutter_bloc package
```dart
abstract class ExampleEvent  {}

class Fetch extends ExampleEvent {
  const Fetch();
}

class Post extends ExampleEvent {
  const Post();
}

class FetchPaginated extends ExampleEvent {
    final int pageKey
  const FetchPaginated(this.pageKey);
}
```
### 3. Define your Bloc

Here you will find new methods in your bloc/cubit, that will act as your event handlers.
- **multiStateApiCall<Event,returnType>**
- **ApiCall**
- **multiStateApiCall<Event,returnType>**
  

```dart
class MultiStateBloc extends Bloc<CommonStateEvent, MultiStateBlocState> {
  MultiStateBloc() : super(MultiStateBlocState()) {
    multiStateApiCall<Fetch, String>(ExampleState.state1, (event) => getSomeDataUseCase());

    multiStateApiCall<Post, bool>(ExampleState.state2, (event) => postSomeDataUseCase());

    // it takes your state name , your callback and the page key
    multiStatePaginatedApiCall<FetchPaginated,String>(ExampleState.state3, (event) => someUseCase(), (event) => event.pageKey);
}
```




# For usage example refer to [Example](https://gitlab.com/humynewversion/common_state/-/tree/main/example?ref_type=heads)
