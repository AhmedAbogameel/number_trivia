import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  sl.registerFactory(
    () => NumberTriviaBloc(
      inputConverter: sl(),
      getRandomNumberTrivia: sl(),
      getConcreteNumberTrivia: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(client: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerLazySingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());

}
