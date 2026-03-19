import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/slider_card.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/slider_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  SliderSubItemModel subItem({required int id, String? headline}) =>
      SliderSubItemModel(id: id, url: 'https://example.com/$id', headline: headline);

  group('SliderCard', () {
    testWidgets('renders SliderPageView', (tester) async {
      final slider = SliderModel(
        id: 1,
        subItems: [subItem(id: 10, headline: 'Item 1')],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SliderCard(slider: slider))),
      );
      await tester.pump();

      expect(find.byType(SliderPageView), findsOneWidget);
    });

    testWidgets('renders headline of sub-item', (tester) async {
      final slider = SliderModel(
        id: 1,
        subItems: [subItem(id: 10, headline: 'Hello World')],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SliderCard(slider: slider))),
      );
      await tester.pump();

      expect(find.text('HELLO WORLD'), findsOneWidget);
    });

    testWidgets('renders pagination dots when multiple sub-items', (tester) async {
      final slider = SliderModel(
        id: 1,
        subItems: [
          subItem(id: 10),
          subItem(id: 11),
          subItem(id: 12),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SliderCard(slider: slider))),
      );
      await tester.pump();

      // 3 dots for 3 sub-items
      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });

    testWidgets('renders no dots when only one sub-item', (tester) async {
      final slider = SliderModel(
        id: 1,
        subItems: [subItem(id: 10)],
      );

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SliderCard(slider: slider))),
      );
      await tester.pump();

      expect(find.byType(AnimatedContainer), findsNothing);
    });

    testWidgets('renders nothing when sub-items are empty', (tester) async {
      final slider = SliderModel(id: 1, subItems: []);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SliderCard(slider: slider))),
      );
      await tester.pump();

      expect(find.byType(PageView), findsNothing);
    });
  });
}
