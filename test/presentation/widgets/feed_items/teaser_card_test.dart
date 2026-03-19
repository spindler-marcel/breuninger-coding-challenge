import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/teaser_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildCard(TeaserModel teaser) {
    return MaterialApp(home: Scaffold(body: TeaserCard(teaser: teaser)));
  }

  group('TeaserCard', () {
    testWidgets('renders headline when present', (tester) async {
      final teaser = TeaserModel(
        id: 1,
        url: 'https://example.com',
        headline: 'Test Headline',
      );

      await tester.pumpWidget(buildCard(teaser));

      expect(find.text('TEST HEADLINE'), findsOneWidget);
    });

    testWidgets('does not render headline when absent', (tester) async {
      final teaser = TeaserModel(id: 1, url: 'https://example.com');

      await tester.pumpWidget(buildCard(teaser));

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders a Card widget', (tester) async {
      final teaser = TeaserModel(id: 1, url: 'https://example.com');

      await tester.pumpWidget(buildCard(teaser));

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
