import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/brand_slider_card.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/slider_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  SliderSubItemModel subItem({required int id}) =>
      SliderSubItemModel(id: id, url: 'https://example.com/$id');

  Widget buildCard(BrandSliderModel brandSlider) => MaterialApp(
        home: Scaffold(body: BrandSliderCard(brandSlider: brandSlider)),
      );

  group('BrandSliderCard', () {
    testWidgets('shows CircularProgressIndicator when subItems is null', (tester) async {
      final brandSlider = BrandSliderModel(
        id: 1,
        itemsUrl: 'https://example.com/brands',
      );

      await tester.pumpWidget(buildCard(brandSlider));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(SliderPageView), findsNothing);
    });

    testWidgets('shows SliderPageView when subItems are loaded', (tester) async {
      final brandSlider = BrandSliderModel(
        id: 1,
        itemsUrl: 'https://example.com/brands',
        subItems: [subItem(id: 10), subItem(id: 11)],
      );

      await tester.pumpWidget(buildCard(brandSlider));
      await tester.pump();

      expect(find.byType(SliderPageView), findsOneWidget);
      // loading SizedBox is gone — identified by its key
      expect(find.byKey(const ValueKey('loading')), findsNothing);
    });

    testWidgets('shows no SliderPageView when subItems is empty list', (tester) async {
      final brandSlider = BrandSliderModel(
        id: 1,
        itemsUrl: 'https://example.com/brands',
        subItems: [],
      );

      await tester.pumpWidget(buildCard(brandSlider));
      await tester.pump();

      expect(find.byType(PageView), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
