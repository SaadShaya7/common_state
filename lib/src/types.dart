import 'package:either_dart/either.dart';

import '../common_state.dart';

typedef FutureResult<T, E> = Future<Either<E, T>>;
typedef States<E> = Map<int, CommonState<dynamic, E>>;
