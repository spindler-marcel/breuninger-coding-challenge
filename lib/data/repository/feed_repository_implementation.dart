import 'dart:convert';

import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/exceptions.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/data/repository/feed_repository.dart';
import 'package:dio/dio.dart';

class FeedRepositoryImplementation implements FeedRepository {
  FeedRepositoryImplementation({required this.dio});

  final Dio dio;

  @override
  Future<List<FeedItem>> getFeed({
    required FeedSource source,
    required CancelToken cancelToken,
  }) async {
    try {
      final response = await dio.get(source.url, cancelToken: cancelToken);
      final raw = response.data;
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is! List)
        throw const NetworkException('Unexpected response format');
      return decoded
          .map((item) => FeedItem.fromJson(item as Map<String, dynamic>))
          .nonNulls
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw NetworkException(e.message ?? 'Network error');
    }
  }

  @override
  Future<List<SliderSubItemModel>> loadBrandItems({
    required String itemsUrl,
    required CancelToken cancelToken,
  }) async {
    try {
      final response = await dio.get(itemsUrl, cancelToken: cancelToken);
      final raw = response.data;
      final decoded = raw is String ? jsonDecode(raw) : raw;
      if (decoded is! Map<String, dynamic>) {
        throw const NetworkException('Unexpected response format');
      }
      final rawItems = decoded['items'];
      if (rawItems is! List)
        throw const NetworkException('Missing items field');
      return rawItems
          .map(
            (item) => SliderSubItemModel.fromJson(item as Map<String, dynamic>),
          )
          .nonNulls
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw NetworkException(e.message ?? 'Network error');
    }
  }
}
