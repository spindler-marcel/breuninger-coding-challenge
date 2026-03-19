import 'package:coding_challenge/data/repository/feed_repository.dart';
import 'package:coding_challenge/data/repository/feed_repository_implementation.dart';
import 'package:coding_challenge/data/repository/feed_repository_mock.dart';
import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

const _useMock = false; // Set to true for performance testing with mock data

void initDependencies() {
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    )),
  );

  sl.registerLazySingleton<FeedRepository>(
    () => _useMock
        ? FeedRepositoryMock()
        : FeedRepositoryImplementation(dio: sl<Dio>()),
  );

  sl.registerFactory<FeedCubit>(
    () => FeedCubit(sl<FeedRepository>()),
  );
}
