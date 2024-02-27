import 'package:common_state/common_state.dart';

import '../utils/error.dart';

typedef AppCommonState<T> = CommonState<T, CustomErrorType>;
typedef Success<T> = SuccessState<T, CustomErrorType>;
typedef Loading<T> = LoadingState<T, CustomErrorType>;
typedef Error<T> = ErrorState<T, CustomErrorType>;
typedef Empty<T> = EmptyState<T, CustomErrorType>;
typedef Initial<T> = InitialState<T, CustomErrorType>;
typedef AppStates = States<CustomErrorType>;
