import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/failures/app_failure.dart';
import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/core/result.dart';
import 'package:coding_challenge/presentation/widgets/feed_grid.dart';
import 'package:coding_challenge/presentation/widgets/feed_list.dart';
import 'package:coding_challenge/presentation/widgets/feed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../widget_test_helpers.dart';

void main() {
  late MockFeedRepository repository;
  late FeedCubit cubit;

  setUp(() {
    repository = MockFeedRepository();
    when(() => repository.cancel()).thenReturn(null);
    cubit = FeedCubit(repository);
  });

  tearDown(() => cubit.close());

  // ─── Loading ───────────────────────────────────────────────────────────────

  group('loading state', () {
    testWidgets('shows CircularProgressIndicator in center', (tester) async {
      cubit.emit(
        FeedInitialLoadingState(
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(cubit, const FeedView(), withScaffold: false),
      );
      await tester.pump();

      // The main loading indicator sits inside a Center widget
      expect(
        find.descendant(
          of: find.byType(Center),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
    });
  });

  // ─── Failure ───────────────────────────────────────────────────────────────

  group('failure state', () {
    testWidgets('shows error message', (tester) async {
      cubit.emit(
        FeedFailureState(
          failure: ServerFailure(),
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(cubit, const FeedView(), withScaffold: false),
      );
      await tester.pump();

      expect(
        find.text('Something went wrong on our end. Please try again later.'),
        findsOneWidget,
      );
    });

    testWidgets('shows retry button', (tester) async {
      cubit.emit(
        FeedFailureState(
          failure: ServerFailure(),
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(cubit, const FeedView(), withScaffold: false),
      );
      await tester.pump();

      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('tapping retry calls getFeed on repository', (tester) async {
      when(
        () => repository.getFeed(source: FeedSource.source1),
      ).thenAnswer((_) async => const Cancelled());

      cubit.emit(
        FeedFailureState(
          failure: ServerFailure(),
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(cubit, const FeedView(), withScaffold: false),
      );
      await tester.pump();

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => repository.getFeed(source: FeedSource.source1)).called(1);
    });
  });

  // ─── Success — responsive layout ───────────────────────────────────────────

  group('success state', () {
    testWidgets('shows FeedList on mobile', (tester) async {
      cubit.emit(
        FeedSuccessState(
          allItems: [],
          displayedItems: [],
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
        ),
      );

      await tester.pumpWidget(
        buildWithSize(cubit, const FeedView(), const Size(390, 844)),
      );
      await tester.pump();

      expect(find.byType(FeedList), findsOneWidget);
      expect(find.byType(FeedGrid), findsNothing);
    });

    testWidgets('shows FeedGrid on tablet', (tester) async {
      cubit.emit(
        FeedSuccessState(
          allItems: [],
          displayedItems: [],
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
        ),
      );

      await tester.pumpWidget(
        buildWithSize(cubit, const FeedView(), const Size(800, 1024)),
      );
      await tester.pump();

      expect(find.byType(FeedGrid), findsOneWidget);
      expect(find.byType(FeedList), findsNothing);
    });

    testWidgets('does not show error message or retry button', (tester) async {
      cubit.emit(
        FeedSuccessState(
          allItems: [],
          displayedItems: [],
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(cubit, const FeedView(), withScaffold: false),
      );
      await tester.pump();

      expect(find.text('Retry'), findsNothing);
      expect(
        find.descendant(
          of: find.byType(Center),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsNothing,
      );
    });
  });

  // ─── Reloading — responsive layout ─────────────────────────────────────────

  group('reloading state', () {
    testWidgets('shows FeedList on mobile', (tester) async {
      cubit.emit(
        FeedReloadingState(
          allItems: [],
          displayedItems: [],
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
          isPullToRefresh: false,
        ),
      );

      await tester.pumpWidget(
        buildWithSize(cubit, const FeedView(), const Size(390, 844)),
      );
      await tester.pump();

      expect(find.byType(FeedList), findsOneWidget);
      expect(find.byType(FeedGrid), findsNothing);
    });

    testWidgets('shows FeedGrid on tablet', (tester) async {
      cubit.emit(
        FeedReloadingState(
          allItems: [],
          displayedItems: [],
          activeSource: FeedSource.source1,
          activeFilter: GenderFilter.all,
          isPullToRefresh: false,
        ),
      );

      await tester.pumpWidget(
        buildWithSize(cubit, const FeedView(), const Size(800, 1024)),
      );
      await tester.pump();

      expect(find.byType(FeedGrid), findsOneWidget);
      expect(find.byType(FeedList), findsNothing);
    });
  });
}
