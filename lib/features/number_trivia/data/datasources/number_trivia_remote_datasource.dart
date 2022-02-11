import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the https://numbersapi.com/{number} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the https://numbersapi.com/random endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
