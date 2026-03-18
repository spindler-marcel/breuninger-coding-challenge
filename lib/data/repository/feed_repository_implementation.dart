import 'dart:convert';

import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/failures/app_failure.dart';
import 'package:coding_challenge/core/failures/dio_exception_parser.dart';
import 'package:coding_challenge/core/result.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/data/repository/feed_repository.dart';
import 'package:dio/dio.dart';

class FeedRepositoryImplementation implements FeedRepository {
  FeedRepositoryImplementation({required this.dio});

  final Dio dio;
  CancelToken _cancelToken = CancelToken();

  @override
  void cancel() {
    _cancelToken.cancel();
    _cancelToken = CancelToken();
  }

  @override
  Future<Result<List<FeedItem>>> getFeed({required FeedSource source}) async {
    final token = _cancelToken;
    try {
      final response = await dio.get(source.url, cancelToken: token);
      final raw = response.data;
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is! List) return Failure(ParseFailure());
      final items = decoded
          .map((item) => FeedItem.fromJson(item as Map<String, dynamic>))
          .nonNulls
          .toList();
      return Success(items);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return const Cancelled();
      return Failure(DioExceptionParser.parse(e));
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<Result<List<SliderSubItemModel>>> loadBrandItems({required String itemsUrl}) async {
    final token = _cancelToken;
    try {
      final response = await dio.get(itemsUrl, cancelToken: token);
      final raw = response.data;
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is! Map<String, dynamic>) return Failure(ParseFailure());
      final rawItems = decoded['items'];
      if (rawItems is! List) return Failure(ParseFailure());
      final items = rawItems
          .map((item) => SliderSubItemModel.fromJson(item as Map<String, dynamic>))
          .nonNulls
          .toList();
      return Success(items);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return const Cancelled();
      return Failure(DioExceptionParser.parse(e));
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }
}
