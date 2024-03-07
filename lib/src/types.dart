import 'package:either_dart/either.dart';

import '../common_state.dart';

typedef FutureResult<T, E> = Future<Either<E, T>>;
typedef States<E> = Map<String, CommonState<dynamic, E>>;
typedef InstanceCreator<T> = T Function(States states);
