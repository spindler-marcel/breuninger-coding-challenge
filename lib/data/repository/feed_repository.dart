import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:dio/dio.dart';

abstract interface class FeedRepository {
  /// Returns the feed for the given [source].
  /// [BrandSliderModel] items are returned immediately with [subItems] == null.
  Future<List<FeedItem>> getFeed({
    required FeedSource source,
    required CancelToken cancelToken,
  });

  /// Secondary fetch for brand slider sub-items.
  Future<List<SliderSubItemModel>> loadBrandItems({
    required String itemsUrl,
    required CancelToken cancelToken,
  });
}
