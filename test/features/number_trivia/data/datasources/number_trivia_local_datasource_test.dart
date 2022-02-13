import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached')));

    test(
      'should return NumberTriviaModel from SharedPreferences when there is one in the cache',
          () async {
        // arrange
            when(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
                .thenReturn(fixture('trivia_cached'));
        // act
            final result = await dataSource.getLastNumberTrivia();
        // assert
            verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
            expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should Throws CacheException when there is no NumberTriviaModel cached',
      () async {
        // arrange
        when(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
            .thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );

  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'text', number: 1);
    final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString))
            .thenAnswer((_) async => true);
        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );
  });

}