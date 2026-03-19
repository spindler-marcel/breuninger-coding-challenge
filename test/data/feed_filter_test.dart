import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/data/feed_filter.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FeedFilter feedFilter;

  setUp(() {
    feedFilter = FeedFilter();
  });

  // ─── Helpers ───────────────────────────────────────────────────────────────

  TeaserModel teaser({required int id, String? gender}) =>
      TeaserModel(id: id, url: 'https://example.com/$id', gender: gender);

  SliderSubItemModel subItem({required int id, String? gender}) =>
      SliderSubItemModel(id: id, url: 'https://example.com/$id', gender: gender);

  SliderModel slider({required int id, required List<SliderSubItemModel> items}) =>
      SliderModel(id: id, subItems: items);

  BrandSliderModel brandSlider({
    required int id,
    List<SliderSubItemModel>? items,
  }) =>
      BrandSliderModel(id: id, itemsUrl: 'https://example.com/brands', subItems: items);

  // ─── GenderFilter.all ──────────────────────────────────────────────────────

  group('GenderFilter.all', () {
    test('keeps all teasers regardless of gender', () {
      final items = [
        teaser(id: 1, gender: 'male'),
        teaser(id: 2, gender: 'female'),
        teaser(id: 3),
      ];

      final result = feedFilter.apply(items, GenderFilter.all);

      expect(result.length, 3);
    });

    test('removes sliders with no sub-items', () {
      final items = [
        slider(id: 1, items: [subItem(id: 10)]),
        slider(id: 2, items: []),
      ];

      final result = feedFilter.apply(items, GenderFilter.all);

      expect(result.length, 1);
      expect(result.first, isA<SliderModel>());
    });

    test('shows brand slider still loading (subItems == null)', () {
      final items = [brandSlider(id: 1)]; // subItems null → still loading

      final result = feedFilter.apply(items, GenderFilter.all);

      expect(result.length, 1);
    });

    test('removes brand slider with empty loaded sub-items', () {
      final items = [brandSlider(id: 1, items: [])];

      final result = feedFilter.apply(items, GenderFilter.all);

      expect(result, isEmpty);
    });
  });

  // ─── GenderFilter.male ─────────────────────────────────────────────────────

  group('GenderFilter.male', () {
    test('keeps male teasers', () {
      final items = [
        teaser(id: 1, gender: 'male'),
        teaser(id: 2, gender: 'female'),
        teaser(id: 3), // no gender → filtered out
      ];

      final result = feedFilter.apply(items, GenderFilter.male);

      expect(result.length, 1);
      expect((result.first as TeaserModel).id, 1);
    });

    test('keeps only male sub-items in slider', () {
      final items = [
        slider(id: 1, items: [
          subItem(id: 10, gender: 'male'),
          subItem(id: 11, gender: 'female'),
        ]),
      ];

      final result = feedFilter.apply(items, GenderFilter.male);

      expect(result.length, 1);
      expect((result.first as SliderModel).subItems.length, 1);
      expect((result.first as SliderModel).subItems.first.gender, 'male');
    });

    test('removes slider when no sub-items match', () {
      final items = [
        slider(id: 1, items: [subItem(id: 10, gender: 'female')]),
      ];

      final result = feedFilter.apply(items, GenderFilter.male);

      expect(result, isEmpty);
    });

    test('shows brand slider still loading', () {
      final items = [brandSlider(id: 1)]; // null → still loading

      final result = feedFilter.apply(items, GenderFilter.male);

      expect(result.length, 1);
    });

    test('keeps only male sub-items in loaded brand slider', () {
      final items = [
        brandSlider(id: 1, items: [
          subItem(id: 10, gender: 'male'),
          subItem(id: 11, gender: 'female'),
        ]),
      ];

      final result = feedFilter.apply(items, GenderFilter.male);

      expect(result.length, 1);
      expect((result.first as BrandSliderModel).subItems!.length, 1);
    });

    test('removes brand slider when no sub-items match', () {
      final items = [
        brandSlider(id: 1, items: [subItem(id: 10, gender: 'female')]),
      ];

      final result = feedFilter.apply(items, GenderFilter.male);

      expect(result, isEmpty);
    });
  });

  // ─── GenderFilter.female ───────────────────────────────────────────────────

  group('GenderFilter.female', () {
    test('keeps female teasers', () {
      final items = [
        teaser(id: 1, gender: 'male'),
        teaser(id: 2, gender: 'female'),
      ];

      final result = feedFilter.apply(items, GenderFilter.female);

      expect(result.length, 1);
      expect((result.first as TeaserModel).id, 2);
    });
  });

  // ─── Mixed item types ──────────────────────────────────────────────────────

  group('mixed items', () {
    test('filters each item type independently', () {
      final items = <FeedItem>[
        teaser(id: 1, gender: 'male'),
        teaser(id: 2, gender: 'female'),
        slider(id: 3, items: [subItem(id: 30, gender: 'male')]),
        brandSlider(id: 4),
      ];

      final result = feedFilter.apply(items, GenderFilter.male);

      expect(result.length, 3); // teaser male, slider, brand slider loading
    });

    test('returns empty list when all items are filtered out', () {
      final items = <FeedItem>[
        teaser(id: 1, gender: 'female'),
        slider(id: 2, items: [subItem(id: 20, gender: 'female')]),
      ];

      final result = feedFilter.apply(items, GenderFilter.male);

      expect(result, isEmpty);
    });
  });
}
