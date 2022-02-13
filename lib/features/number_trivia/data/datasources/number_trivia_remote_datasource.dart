import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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

const String BASE_URL = 'http://numbersapi.com/';

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl('$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl('random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String path) async {
    final url = Uri.parse(BASE_URL + path);
    final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        }
    );
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return NumberTriviaModel.fromJson(decodedResponse);
    } else {
      throw ServerException();
    }
  }

}