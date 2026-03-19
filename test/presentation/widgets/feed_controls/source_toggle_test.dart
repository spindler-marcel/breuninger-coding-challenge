import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/result.dart';
import 'package:coding_challenge/presentation/widgets/feed_controls/source_toggle.dart';
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

  group('SourceToggle', () {
    testWidgets('renders labels for both sources', (tester) async {
      await tester.pumpWidget(buildTestWidget(cubit, const SourceToggle()));
      await tester.pumpAndSettle();

      expect(find.text('Source 1'), findsOneWidget);
      expect(find.text('Source 2'), findsOneWidget);
    });

    testWidgets('tapping "Source 2" switches active source', (tester) async {
      when(() => repository.getFeed(source: FeedSource.source2))
          .thenAnswer((_) async => const Success([]));

      await tester.pumpWidget(buildTestWidget(cubit, const SourceToggle()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Source 2'));
      await tester.pumpAndSettle();

      expect(cubit.state.activeSource, FeedSource.source2);
    });

    testWidgets('tapping "Source 1" when already on source 1 does nothing', (tester) async {
      await tester.pumpWidget(buildTestWidget(cubit, const SourceToggle()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Source 1'));
      await tester.pumpAndSettle();

      expect(cubit.state.activeSource, FeedSource.source1);
      verifyNever(() => repository.getFeed(source: FeedSource.source1));
      verifyNever(() => repository.getFeed(source: FeedSource.source2));
    });
  });
}
