import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/result.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/data/repository/feed_repository.dart';

/// Mock repository with 100 items per source for testing app performance.
/// IDs 1–60: shared between both sources
/// IDs 61–100: unique to source 1
/// IDs 101–140: unique to source 2
class FeedRepositoryMock implements FeedRepository {
  static TeaserModel _teaser(int id, {String? gender}) => TeaserModel(
    id: id,
    gender: gender,
    expiresAt: DateTime(2026, 12, 31),
    headline: "Teaser $id",
    imageUrl: "https://picsum.photos/seed/$id/400/300",
    url: "https://example.com/teaser/$id",
  );

  static SliderSubItemModel _subItem(int id, {String? gender}) =>
      SliderSubItemModel(
        id: id,
        gender: gender,
        headline: "Item $id",
        imageUrl: "https://picsum.photos/seed/$id/400/300",
        url: "https://example.com/item/$id",
      );

  static SliderModel _slider(int id) => SliderModel(
    id: id,
    subItems: [
      _subItem(id * 100 + 1, gender: "male"),
      _subItem(id * 100 + 2, gender: "female"),
      _subItem(id * 100 + 3, gender: "male"),
    ],
  );

  static BrandSliderModel _brandSlider(int id) => BrandSliderModel(
    id: id,
    itemsUrl: "",
    subItems: [
      _subItem(id * 100 + 10, gender: "male"),
      _subItem(id * 100 + 11, gender: "female"),
    ],
  );

  static FeedItem _item(int id) {
    if (id % 10 == 0) return _brandSlider(id);
    if (id % 3 == 0) return _slider(id);
    if (id % 2 == 0) return _teaser(id, gender: "male");
    return _teaser(id, gender: "female");
  }

  static final _source1 = List.generate(100, (i) => _item(i + 1));
  static final _source2 = [
    ...List.generate(60, (i) => _item(i + 1)), // shared
    ...List.generate(40, (i) => _item(i + 101)), // unique to source 2
  ];

  @override
  void cancel() {}

  @override
  Future<Result<List<FeedItem>>> getFeed({required FeedSource source}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return Success(source == FeedSource.source1 ? _source1 : _source2);
  }

  @override
  Future<Result<List<SliderSubItemModel>>> loadBrandItems({
    required String itemsUrl,
  }) async {
    return const Success([]);
  }
}
