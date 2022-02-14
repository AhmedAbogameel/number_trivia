import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - Number must be an integer and above 0 ';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.inputConverter,
    required this.getRandomNumberTrivia,
    required this.getConcreteNumberTrivia,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(
      (event, emit) {
        final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither.fold(
          (failure) => emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) async {
            emit(Loading());
            final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
            _eitherLoadedOrErrorState(emit, failureOrTrivia);
          },
        );
      },
    );

    on<GetTriviaForRandomNumber>(
      (event, emit) async {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        _eitherLoadedOrErrorState(emit, failureOrTrivia);
      },
    );
  }

  void _eitherLoadedOrErrorState(Emitter emit,Either<Failure, NumberTrivia> failureOrTrivia) =>
    failureOrTrivia.fold(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))),
          (trivia) => emit(Loaded(numberTrivia: trivia)),
    );

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
