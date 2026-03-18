import 'package:coding_challenge/core/failures/app_failure.dart';
import 'package:dio/dio.dart';

class DioExceptionParser {
  static AppFailure parse(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        TimeoutFailure(),
      DioExceptionType.badResponse => ServerFailure(),
      DioExceptionType.connectionError => ConnectionFailure(),
      _ => UnknownFailure(),
    };
  }
}
