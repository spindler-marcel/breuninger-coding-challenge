import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeaserModel', () {
    test('fromJson parses valid teaser', () {
      final json = {
        'type': 'teaser',
        'id': 1,
        'gender': 'female',
        'expires_at': '2025-12-31T00:00:00.000Z',
        'attributes': {
          'url': 'https://example.com',
          'headline': 'Test Headline',
          'image_url': 'https://example.com/image.jpg',
        },
      };

      final result = TeaserModel.fromJson(json);

      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.url, 'https://example.com');
      expect(result.gender, 'female');
      expect(result.headline, 'Test Headline');
      expect(result.imageUrl, 'https://example.com/image.jpg');
      expect(result.expiresAt, DateTime.tryParse('2025-12-31T00:00:00.000Z'));
    });

    test('fromJson returns null when url is missing', () {
      final json = {
        'type': 'teaser',
        'id': 1,
        'attributes': <String, dynamic>{},
      };

      final result = TeaserModel.fromJson(json);

      expect(result, isNull);
    });

    test('fromJson handles optional fields being null', () {
      final json = {
        'type': 'teaser',
        'id': 2,
        'attributes': {
          'url': 'https://example.com',
        },
      };

      final result = TeaserModel.fromJson(json);

      expect(result, isNotNull);
      expect(result!.gender, isNull);
      expect(result.headline, isNull);
      expect(result.imageUrl, isNull);
      expect(result.expiresAt, isNull);
    });
  });

  group('SliderModel', () {
    test('fromJson parses valid slider with sub-items', () {
      final json = {
        'type': 'slider',
        'id': 10,
        'attributes': {
          'items': [
            {
              'id': 101,
              'url': 'https://example.com/1',
              'gender': 'male',
              'headline': 'Sub 1',
              'image_url': null,
            },
            {
              'id': 102,
              'url': 'https://example.com/2',
              'gender': 'female',
              'headline': 'Sub 2',
              'image_url': null,
            },
          ],
        },
      };

      final result = SliderModel.fromJson(json);

      expect(result.id, 10);
      expect(result.subItems.length, 2);
      expect(result.subItems[0].id, 101);
      expect(result.subItems[0].gender, 'male');
      expect(result.subItems[1].id, 102);
    });

    test('fromJson skips sub-items with missing url', () {
      final json = {
        'type': 'slider',
        'id': 10,
        'attributes': {
          'items': [
            {'id': 101, 'url': 'https://example.com'},
            {'id': 102}, // missing url → skipped
          ],
        },
      };

      final result = SliderModel.fromJson(json);

      expect(result.subItems.length, 1);
      expect(result.subItems[0].id, 101);
    });
  });

  group('BrandSliderModel', () {
    test('fromJson parses valid brand slider', () {
      final json = {
        'type': 'brand_slider',
        'id': 20,
        'attributes': {
          'items_url': 'https://example.com/brands',
        },
      };

      final result = BrandSliderModel.fromJson(json);

      expect(result.id, 20);
      expect(result.itemsUrl, 'https://example.com/brands');
      expect(result.subItems, isNull);
    });

    test('copyWithSubItems creates new instance with sub-items', () {
      final original = BrandSliderModel(id: 20, itemsUrl: 'https://example.com/brands');
      final subItems = [
        SliderSubItemModel(id: 1, url: 'https://example.com/1'),
        SliderSubItemModel(id: 2, url: 'https://example.com/2'),
      ];

      final copy = original.copyWithSubItems(subItems);

      expect(copy.id, original.id);
      expect(copy.itemsUrl, original.itemsUrl);
      expect(copy.subItems, subItems);
    });
  });

  group('FeedItem.fromJson', () {
    test('parses teaser type', () {
      final json = {
        'type': 'teaser',
        'id': 1,
        'attributes': {'url': 'https://example.com'},
      };
      expect(FeedItem.fromJson(json), isA<TeaserModel>());
    });

    test('parses slider type', () {
      final json = {
        'type': 'slider',
        'id': 2,
        'attributes': {'items': <dynamic>[]},
      };
      expect(FeedItem.fromJson(json), isA<SliderModel>());
    });

    test('parses brand_slider type', () {
      final json = {
        'type': 'brand_slider',
        'id': 3,
        'attributes': {'items_url': 'https://example.com/brands'},
      };
      expect(FeedItem.fromJson(json), isA<BrandSliderModel>());
    });

    test('returns null for unknown type', () {
      final json = {'type': 'unknown', 'id': 4, 'attributes': <String, dynamic>{}};
      expect(FeedItem.fromJson(json), isNull);
    });

    test('returns null on parse error', () {
      final json = {'type': 'teaser', 'id': 'not_an_int', 'attributes': <String, dynamic>{}};
      expect(FeedItem.fromJson(json), isNull);
    });
  });
}
