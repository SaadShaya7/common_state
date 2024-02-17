import 'package:either_dart/either.dart';

typedef FutureResult<T, E> = Future<Either<E, T>>;
