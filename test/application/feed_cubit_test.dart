import 'package:bloc_test/bloc_test.dart';
import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/failures/app_failure.dart';
import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/core/result.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late MockFeedRepository repository;

  setUp(() {
    repository = MockFeedRepository();
    when(() => repository.cancel()).thenReturn(null);
  });

  TeaserModel teaser({required int id, String? gender}) =>
      TeaserModel(id: id, url: 'https://example.com/$id', gender: gender);

  SliderSubItemModel subItem({required int id, String? gender}) =>
      SliderSubItemModel(
        id: id,
        url: 'https://example.com/$id',
        gender: gender,
      );

  BrandSliderModel brandSlider({required int id}) =>
      BrandSliderModel(id: id, itemsUrl: 'https://example.com/brands');

  void stubFeedSuccess(
    List<FeedItem> items, {
    FeedSource source = FeedSource.source1,
  }) {
    when(
      () => repository.getFeed(source: source),
    ).thenAnswer((_) async => Success(items));
  }

  void stubFeedFailure({
    AppFailure? failure,
    FeedSource source = FeedSource.source1,
  }) {
    when(
      () => repository.getFeed(source: source),
    ).thenAnswer((_) async => Failure(failure ?? ServerFailure()));
  }

  void stubFeedCancelled({FeedSource source = FeedSource.source1}) {
    when(
      () => repository.getFeed(source: source),
    ).thenAnswer((_) async => const Cancelled());
  }

  test('initial state is FeedInitialState', () {
    final cubit = FeedCubit(repository);
    expect(cubit.state, isA<FeedInitialState>());
    cubit.close();
  });

  group('refresh', () {
    blocTest<FeedCubit, FeedState>(
      'emits [InitialLoading, Success] on first successful load',
      build: () {
        stubFeedSuccess([teaser(id: 1), teaser(id: 2)]);
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<FeedInitialLoadingState>(),
        isA<FeedSuccessState>().having(
          (s) => s.allItems.length,
          'allItems.length',
          2,
        ),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'emits [InitialLoading, Failure] on network error',
      build: () {
        stubFeedFailure(failure: ConnectionFailure());
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<FeedInitialLoadingState>(),
        isA<FeedFailureState>().having(
          (s) => s.failure,
          'failure',
          isA<ConnectionFailure>(),
        ),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'emits [Reloading(isPullToRefresh: true), Success] when refreshing from success',
      build: () {
        stubFeedSuccess([teaser(id: 1)]);
        return FeedCubit(repository);
      },
      seed: () => FeedSuccessState(
        allItems: [teaser(id: 1)],
        displayedItems: [teaser(id: 1)],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.all,
      ),
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<FeedReloadingState>().having(
          (s) => s.isPullToRefresh,
          'isPullToRefresh',
          true,
        ),
        isA<FeedSuccessState>(),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'emits only [InitialLoading] on cancelled request',
      build: () {
        stubFeedCancelled();
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [isA<FeedInitialLoadingState>()],
    );

    blocTest<FeedCubit, FeedState>(
      'calls repository.cancel() before loading',
      build: () {
        stubFeedSuccess([]);
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.refresh(),
      verify: (_) =>
          verify(() => repository.cancel()).called(greaterThanOrEqualTo(1)),
    );

    blocTest<FeedCubit, FeedState>(
      'activeSource and activeFilter are preserved in loading state',
      build: () {
        stubFeedSuccess([], source: FeedSource.source2);
        return FeedCubit(repository);
      },
      seed: () => FeedSuccessState(
        allItems: [],
        displayedItems: [],
        activeSource: FeedSource.source2,
        activeFilter: GenderFilter.female,
      ),
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<FeedReloadingState>()
            .having((s) => s.activeSource, 'activeSource', FeedSource.source2)
            .having((s) => s.activeFilter, 'activeFilter', GenderFilter.female),
        isA<FeedSuccessState>(),
      ],
    );
  });

  group('switchSource', () {
    blocTest<FeedCubit, FeedState>(
      'emits nothing when switching to the same source',
      build: () => FeedCubit(repository),
      act: (cubit) => cubit.switchSource(FeedSource.source1),
      expect: () => [],
    );

    blocTest<FeedCubit, FeedState>(
      'emits [InitialLoading(source2), Success(source2)] from initial state',
      build: () {
        stubFeedSuccess([teaser(id: 99)], source: FeedSource.source2);
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.switchSource(FeedSource.source2),
      expect: () => [
        isA<FeedInitialLoadingState>().having(
          (s) => s.activeSource,
          'activeSource',
          FeedSource.source2,
        ),
        isA<FeedSuccessState>().having(
          (s) => s.activeSource,
          'activeSource',
          FeedSource.source2,
        ),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'emits [Reloading(isPullToRefresh: false), Success] when switching from success',
      build: () {
        stubFeedSuccess([teaser(id: 99)], source: FeedSource.source2);
        return FeedCubit(repository);
      },
      seed: () => FeedSuccessState(
        allItems: [teaser(id: 1)],
        displayedItems: [teaser(id: 1)],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.all,
      ),
      act: (cubit) => cubit.switchSource(FeedSource.source2),
      expect: () => [
        isA<FeedReloadingState>()
            .having((s) => s.activeSource, 'activeSource', FeedSource.source2)
            .having((s) => s.isPullToRefresh, 'isPullToRefresh', false),
        isA<FeedSuccessState>().having(
          (s) => s.activeSource,
          'activeSource',
          FeedSource.source2,
        ),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'emits [Reloading, Success] when switching from reloading state',
      build: () {
        stubFeedSuccess([teaser(id: 99)], source: FeedSource.source2);
        return FeedCubit(repository);
      },
      seed: () => FeedReloadingState(
        allItems: [teaser(id: 1)],
        displayedItems: [teaser(id: 1)],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.all,
        isPullToRefresh: false,
      ),
      act: (cubit) => cubit.switchSource(FeedSource.source2),
      expect: () => [
        isA<FeedReloadingState>()
            .having((s) => s.activeSource, 'activeSource', FeedSource.source2)
            .having((s) => s.isPullToRefresh, 'isPullToRefresh', false),
        isA<FeedSuccessState>(),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'emits [InitialLoading, Failure] when new source returns error',
      build: () {
        stubFeedFailure(failure: ServerFailure(), source: FeedSource.source2);
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.switchSource(FeedSource.source2),
      expect: () => [
        isA<FeedInitialLoadingState>(),
        isA<FeedFailureState>()
            .having((s) => s.failure, 'failure', isA<ServerFailure>())
            .having((s) => s.activeSource, 'activeSource', FeedSource.source2),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'calls repository.cancel() before loading new source',
      build: () {
        stubFeedSuccess([], source: FeedSource.source2);
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.switchSource(FeedSource.source2),
      verify: (_) =>
          verify(() => repository.cancel()).called(greaterThanOrEqualTo(1)),
    );
  });

  group('filterByGender', () {
    blocTest<FeedCubit, FeedState>(
      'does nothing when not in FeedSuccessState',
      build: () => FeedCubit(repository),
      act: (cubit) => cubit.filterByGender(GenderFilter.male),
      expect: () => [],
    );

    blocTest<FeedCubit, FeedState>(
      'filters displayedItems without changing allItems',
      build: () => FeedCubit(repository),
      seed: () => FeedSuccessState(
        allItems: [
          teaser(id: 1, gender: 'male'),
          teaser(id: 2, gender: 'female'),
          teaser(id: 3, gender: 'female'),
        ],
        displayedItems: [
          teaser(id: 1, gender: 'male'),
          teaser(id: 2, gender: 'female'),
          teaser(id: 3, gender: 'female'),
        ],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.all,
      ),
      act: (cubit) => cubit.filterByGender(GenderFilter.female),
      expect: () => [
        isA<FeedSuccessState>()
            .having((s) => s.allItems.length, 'allItems.length', 3)
            .having((s) => s.displayedItems.length, 'displayedItems.length', 2)
            .having((s) => s.activeFilter, 'activeFilter', GenderFilter.female),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'filters sliders and brand sliders by gender',
      build: () => FeedCubit(repository),
      seed: () => FeedSuccessState(
        allItems: <FeedItem>[
          teaser(id: 1, gender: 'male'),
          SliderModel(
            id: 2,
            subItems: [
              subItem(id: 20, gender: 'male'),
              subItem(id: 21, gender: 'female'),
            ],
          ),
          BrandSliderModel(
            id: 3,
            itemsUrl: 'https://example.com/brands',
            subItems: [subItem(id: 30, gender: 'female')],
          ),
        ],
        displayedItems: [],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.all,
      ),
      act: (cubit) => cubit.filterByGender(GenderFilter.male),
      expect: () => [
        isA<FeedSuccessState>().having(
          (s) => s.displayedItems.length,
          'displayedItems.length',
          2,
        ),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'switching filter back to all restores all items in displayedItems',
      build: () => FeedCubit(repository),
      seed: () => FeedSuccessState(
        allItems: [
          teaser(id: 1, gender: 'male'),
          teaser(id: 2, gender: 'female'),
        ],
        displayedItems: [teaser(id: 1, gender: 'male')],
        activeSource: FeedSource.source1,
        activeFilter: GenderFilter.male,
      ),
      act: (cubit) => cubit.filterByGender(GenderFilter.all),
      expect: () => [
        isA<FeedSuccessState>()
            .having((s) => s.displayedItems.length, 'displayedItems.length', 2)
            .having((s) => s.activeFilter, 'activeFilter', GenderFilter.all),
      ],
    );
  });

  group('brand slider', () {
    blocTest<FeedCubit, FeedState>(
      'emits second Success with loaded sub-items after brand fetch',
      build: () {
        final brand = brandSlider(id: 5);
        when(
          () => repository.getFeed(source: FeedSource.source1),
        ).thenAnswer((_) async => Success([brand]));
        when(
          () => repository.loadBrandItems(itemsUrl: brand.itemsUrl),
        ).thenAnswer((_) async => Success([subItem(id: 50)]));
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<FeedInitialLoadingState>(),
        isA<FeedSuccessState>().having(
          (s) => (s.allItems.first as BrandSliderModel).subItems,
          'subItems before load',
          isNull,
        ),
        isA<FeedSuccessState>().having(
          (s) => (s.allItems.first as BrandSliderModel).subItems?.length,
          'subItems after load',
          1,
        ),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'removes brand slider from list when brand fetch fails',
      build: () {
        final brand = brandSlider(id: 5);
        when(
          () => repository.getFeed(source: FeedSource.source1),
        ).thenAnswer((_) async => Success([teaser(id: 1), brand]));
        when(
          () => repository.loadBrandItems(itemsUrl: brand.itemsUrl),
        ).thenAnswer((_) async => Failure(ServerFailure()));
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<FeedInitialLoadingState>(),
        isA<FeedSuccessState>().having(
          (s) => s.allItems.length,
          'with brand',
          2,
        ),
        isA<FeedSuccessState>().having(
          (s) => s.allItems.length,
          'without brand',
          1,
        ),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'removes brand slider from list when all sub-items fail to parse',
      build: () {
        final brand = brandSlider(id: 5);
        when(
          () => repository.getFeed(source: FeedSource.source1),
        ).thenAnswer((_) async => Success([teaser(id: 1), brand]));
        when(
          () => repository.loadBrandItems(itemsUrl: brand.itemsUrl),
        ).thenAnswer((_) async => const Success([]));
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<FeedInitialLoadingState>(),
        isA<FeedSuccessState>().having(
          (s) => s.allItems.length,
          'with brand',
          2,
        ),
        isA<FeedSuccessState>().having(
          (s) => s.allItems.length,
          'without brand',
          1,
        ),
      ],
    );

    blocTest<FeedCubit, FeedState>(
      'emits nothing after brand fetch when request was cancelled',
      build: () {
        final brand = brandSlider(id: 5);
        when(
          () => repository.getFeed(source: FeedSource.source1),
        ).thenAnswer((_) async => Success([brand]));
        when(
          () => repository.loadBrandItems(itemsUrl: brand.itemsUrl),
        ).thenAnswer((_) async => const Cancelled());
        return FeedCubit(repository);
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [isA<FeedInitialLoadingState>(), isA<FeedSuccessState>()],
    );
  });
}
