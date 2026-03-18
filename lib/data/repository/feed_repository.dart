import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/result.dart';
import 'package:coding_challenge/data/models/feed_models.dart';

abstract interface class FeedRepository {
  void cancel();

  /// Returns the feed for the given [source].
  /// [BrandSliderModel] items are returned immediately with [subItems] == null.
  Future<Result<List<FeedItem>>> getFeed({required FeedSource source});

  /// Secondary fetch for brand slider sub-items.
  Future<Result<List<SliderSubItemModel>>> loadBrandItems({required String itemsUrl});
}
