import 'package:common_state/common_state.dart';

import '../models/error.dart';

typedef AppStates = States<CustomErrorType>;

typedef AppCommonState<T> = CommonState<T, CustomErrorType>;
typedef Success<T> = SuccessState<T, CustomErrorType>;
typedef Loading<T> = LoadingState<T, CustomErrorType>;
typedef Failure<T> = FailureState<T, CustomErrorType>;
typedef Empty<T> = EmptyState<T, CustomErrorType>;
typedef Initial<T> = InitialState<T, CustomErrorType>;