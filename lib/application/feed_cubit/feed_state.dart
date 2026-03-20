part of 'feed_cubit.dart';

sealed class FeedState {
  const FeedState();
  FeedSource get activeSource;
  GenderFilter get activeFilter;
}

final class FeedInitialState extends FeedState with EquatableMixin {
  @override
  FeedSource get activeSource => FeedSource.source1;
  @override
  GenderFilter get activeFilter => GenderFilter.all;
  @override
  List<Object?> get props => [];
}

final class FeedInitialLoadingState extends FeedState with EquatableMixin {
  @override
  final FeedSource activeSource;
  @override
  final GenderFilter activeFilter;

  const FeedInitialLoadingState({
    required this.activeSource,
    required this.activeFilter,
  });

  FeedInitialLoadingState copyWith({
    FeedSource? activeSource,
    GenderFilter? activeFilter,
  }) => FeedInitialLoadingState(
    activeSource: activeSource ?? this.activeSource,
    activeFilter: activeFilter ?? this.activeFilter,
  );

  @override
  List<Object?> get props => [activeSource, activeFilter];
}

final class FeedReloadingState extends FeedState with EquatableMixin {
  @override
  final FeedSource activeSource;
  @override
  final GenderFilter activeFilter;
  final List<FeedItem> allItems;
  final List<FeedItem> displayedItems;
  final bool isPullToRefresh;

  const FeedReloadingState({
    required this.allItems,
    required this.displayedItems,
    required this.activeSource,
    required this.activeFilter,
    required this.isPullToRefresh,
  });

  FeedReloadingState copyWith({
    FeedSource? activeSource,
    GenderFilter? activeFilter,
    List<FeedItem>? allItems,
    List<FeedItem>? displayedItems,
    bool? isPullToRefresh,
  }) => FeedReloadingState(
    activeSource: activeSource ?? this.activeSource,
    activeFilter: activeFilter ?? this.activeFilter,
    allItems: allItems ?? this.allItems,
    displayedItems: displayedItems ?? this.displayedItems,
    isPullToRefresh: isPullToRefresh ?? this.isPullToRefresh,
  );

  @override
  List<Object?> get props => [
    allItems,
    displayedItems,
    activeSource,
    activeFilter,
    isPullToRefresh,
  ];
}

final class FeedSuccessState extends FeedState with EquatableMixin {
  @override
  final FeedSource activeSource;
  @override
  final GenderFilter activeFilter;
  final List<FeedItem> allItems;
  final List<FeedItem> displayedItems;

  const FeedSuccessState({
    required this.allItems,
    required this.displayedItems,
    required this.activeSource,
    required this.activeFilter,
  });

  FeedSuccessState copyWith({
    FeedSource? activeSource,
    GenderFilter? activeFilter,
    List<FeedItem>? allItems,
    List<FeedItem>? displayedItems,
  }) => FeedSuccessState(
    activeSource: activeSource ?? this.activeSource,
    activeFilter: activeFilter ?? this.activeFilter,
    allItems: allItems ?? this.allItems,
    displayedItems: displayedItems ?? this.displayedItems,
  );

  @override
  List<Object?> get props => [
    allItems,
    displayedItems,
    activeSource,
    activeFilter,
  ];
}

final class FeedFailureState extends FeedState with EquatableMixin {
  @override
  final FeedSource activeSource;
  @override
  final GenderFilter activeFilter;
  final AppFailure failure;

  const FeedFailureState({
    required this.failure,
    required this.activeSource,
    required this.activeFilter,
  });

  FeedFailureState copyWith({
    FeedSource? activeSource,
    GenderFilter? activeFilter,
    AppFailure? failure,
  }) => FeedFailureState(
    activeSource: activeSource ?? this.activeSource,
    activeFilter: activeFilter ?? this.activeFilter,
    failure: failure ?? this.failure,
  );

  @override
  List<Object?> get props => [failure, activeSource, activeFilter];
}
