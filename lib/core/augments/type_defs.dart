import 'package:fpdart/fpdart.dart' show Either;
import 'package:vinews_news_reader/core/augments/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>; 