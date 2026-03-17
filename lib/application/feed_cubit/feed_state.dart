part of 'feed_cubit.dart';

sealed class FeedState {
  const FeedState();
}

final class FeedInitialState extends FeedState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class FeedLoadingState extends FeedState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

final class FeedSuccessState extends FeedState with EquatableMixin {
  const FeedSuccessState({
    required this.allItems,
    required this.displayedItems,
    required this.activeSource,
    required this.activeFilter,
  });

  final List<FeedItem> allItems;
  final List<FeedItem> displayedItems;
  final FeedSource activeSource;
  final GenderFilter activeFilter;

  @override
  List<Object?> get props => [allItems, displayedItems, activeSource, activeFilter];
}

final class FeedFailureState extends FeedState with EquatableMixin {
  const FeedFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
