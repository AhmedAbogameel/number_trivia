import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {

  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  final jsonResponse = fixture('trivia');
  final tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(jsonResponse));

  final tNumberUrl = Uri.parse(BASE_URL + '$tNumber');
  final tRandomUrl = Uri.parse(BASE_URL + 'random');

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(jsonResponse, 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Not Found', 404));
  }

  group('getConcreteNumberTrivia', () {

    test(
      '''should perform a GET request on a URL with number
       being the endpoint with application/json in headers''',
      () async {
        // arrange
       setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
          mockHttpClient.get(
            tNumberUrl,
            headers: {'Content-Type': 'application/json'}
          )
        );
      },
    );

    test(
      'should return NumberTrivia when status code is 200',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when status code is not 200',
      () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );

  });


  group('getRandomNumberTrivia', () {

    test(
      '''should perform a GET request on a URL with random
       being the endpoint with application/json in headers''',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(
            mockHttpClient.get(
              tRandomUrl,
              headers: {'Content-Type': 'application/json'}
            )
        );
      },
    );

    test(
      'should return NumberTrivia when status code is 200',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when status code is not 200',
          () async {
        // arrange
        setUpMockHttpClientFailure();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );

  });


}