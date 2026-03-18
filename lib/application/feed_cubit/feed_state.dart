part of 'feed_cubit.dart';

sealed class FeedState {
  const FeedState();
}

final class FeedInitialState extends FeedState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class FeedInitialLoadingState extends FeedState with EquatableMixin {
  const FeedInitialLoadingState({
    required this.activeSource,
    required this.activeFilter,
  });

  final FeedSource activeSource;
  final GenderFilter activeFilter;

  @override
  List<Object?> get props => [activeSource, activeFilter];
}

final class FeedSuccessState extends FeedState with EquatableMixin {
  const FeedSuccessState({
    required this.allItems,
    required this.displayedItems,
    required this.activeSource,
    required this.activeFilter,
    this.isReloading = false,
  });

  final List<FeedItem> allItems;
  final List<FeedItem> displayedItems;
  final FeedSource activeSource;
  final GenderFilter activeFilter;
  final bool isReloading;

  FeedSuccessState copyWith({
    List<FeedItem>? allItems,
    List<FeedItem>? displayedItems,
    FeedSource? activeSource,
    GenderFilter? activeFilter,
    bool? isReloading,
  }) {
    return FeedSuccessState(
      allItems: allItems ?? this.allItems,
      displayedItems: displayedItems ?? this.displayedItems,
      activeSource: activeSource ?? this.activeSource,
      activeFilter: activeFilter ?? this.activeFilter,
      isReloading: isReloading ?? this.isReloading,
    );
  }

  @override
  List<Object?> get props => [allItems, displayedItems, activeSource, activeFilter, isReloading];
}

final class FeedFailureState extends FeedState with EquatableMixin {
  const FeedFailureState({
    required this.failure,
    required this.activeSource,
    required this.activeFilter,
  });

  final AppFailure failure;
  final FeedSource activeSource;
  final GenderFilter activeFilter;

  @override
  List<Object?> get props => [failure, activeSource, activeFilter];
}
