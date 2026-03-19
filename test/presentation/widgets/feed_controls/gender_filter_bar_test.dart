import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/feed_controls/gender_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../../widget_test_helpers.dart';

void main() {
  late MockFeedRepository repository;
  late FeedCubit cubit;

  setUp(() {
    repository = MockFeedRepository();
    when(() => repository.cancel()).thenReturn(null);
    cubit = FeedCubit(repository);
  });

  tearDown(() => cubit.close());

  group('GenderFilterBar', () {
    testWidgets('renders all three filter chips', (tester) async {
      await tester.pumpWidget(buildTestWidget(cubit, const GenderFilterBar()));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
      expect(find.text('Female'), findsOneWidget);
    });

    testWidgets('"All" chip is selected in initial state', (tester) async {
      await tester.pumpWidget(buildTestWidget(cubit, const GenderFilterBar()));
      await tester.pumpAndSettle();

      final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip)).toList();
      final allChip = chips.firstWhere((c) => (c.label as Text).data == 'All');

      expect(allChip.selected, isTrue);
    });

    testWidgets('tapping "Male" chip updates active filter', (tester) async {
      cubit.emit(FeedSuccessState(
        allItems: [TeaserModel(id: 1, url: 'https://example.com', gender: 'male')],
        displayedItems: [TeaserModel(id: 1, url: 'https://example.com', gender: 'male')],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.all,
      ));

      await tester.pumpWidget(buildTestWidget(cubit, const GenderFilterBar()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Male'));
      await tester.pumpAndSettle();

      expect((cubit.state as FeedSuccessState).activeFilter, GenderFilter.male);
    });

    testWidgets('tapping "Female" chip updates active filter', (tester) async {
      cubit.emit(FeedSuccessState(
        allItems: [TeaserModel(id: 1, url: 'https://example.com', gender: 'female')],
        displayedItems: [TeaserModel(id: 1, url: 'https://example.com', gender: 'female')],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.all,
      ));

      await tester.pumpWidget(buildTestWidget(cubit, const GenderFilterBar()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Female'));
      await tester.pumpAndSettle();

      expect((cubit.state as FeedSuccessState).activeFilter, GenderFilter.female);
    });

    testWidgets('"Male" chip is marked selected when filter is male', (tester) async {
      cubit.emit(FeedSuccessState(
        allItems: [],
        displayedItems: [],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.male,
      ));

      await tester.pumpWidget(buildTestWidget(cubit, const GenderFilterBar()));
      await tester.pumpAndSettle();

      final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip)).toList();
      final maleChip = chips.firstWhere((c) => (c.label as Text).data == 'Male');

      expect(maleChip.selected, isTrue);
    });

    testWidgets('"Female" chip is marked selected when filter is female', (tester) async {
      cubit.emit(FeedSuccessState(
        allItems: [],
        displayedItems: [],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.female,
      ));

      await tester.pumpWidget(buildTestWidget(cubit, const GenderFilterBar()));
      await tester.pumpAndSettle();

      final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip)).toList();
      final femaleChip = chips.firstWhere((c) => (c.label as Text).data == 'Female');

      expect(femaleChip.selected, isTrue);
    });
  });
}
