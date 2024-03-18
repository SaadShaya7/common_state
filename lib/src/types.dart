import 'package:either_dart/either.dart';

import '../common_state.dart';

typedef CommonStateFutureResult<T> = Future<Either<dynamic, T>>;
typedef States<E> = Map<String, CommonState>;
typedef InstanceCreator<T> = T Function(States states);
