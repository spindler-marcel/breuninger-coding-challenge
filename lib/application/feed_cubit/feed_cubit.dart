import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/failures/app_failure.dart';
import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/core/result.dart';
import 'package:coding_challenge/data/feed_filter.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/data/repository/feed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(this._repository) : super(FeedInitialState());

  final FeedRepository _repository;
  final FeedFilter _filter = FeedFilter();
  int _requestId = 0;

  Future<void> refresh() async {
    final currentState = state;
    final source = currentState.activeSource;
    final filter = currentState.activeFilter;
    _repository.cancel();
    final requestId = ++_requestId;
    switch (currentState) {
      case FeedSuccessState s:
        emit(FeedReloadingState(
          allItems: s.allItems, displayedItems: s.displayedItems,
          activeSource: source, activeFilter: filter, isPullToRefresh: true,
        ));
      case FeedReloadingState s:
        emit(s.copyWith(isPullToRefresh: true));
      default:
        emit(FeedInitialLoadingState(activeSource: source, activeFilter: filter));
    }
    await _loadFeed(source: source, filter: filter, requestId: requestId);
  }

  Future<void> switchSource(FeedSource newSource) async {
    final currentState = state;
    if (currentState.activeSource == newSource) return;
    final filter = currentState.activeFilter;

    _repository.cancel();
    final requestId = ++_requestId;
    switch (currentState) {
      case FeedSuccessState s:
        emit(FeedReloadingState(
          allItems: s.allItems, displayedItems: s.displayedItems,
          activeSource: newSource, activeFilter: filter, isPullToRefresh: false,
        ));
      case FeedReloadingState s:
        emit(s.copyWith(activeSource: newSource, isPullToRefresh: false));
      default:
        emit(FeedInitialLoadingState(activeSource: newSource, activeFilter: filter));
    }
    await _loadFeed(source: newSource, filter: filter, requestId: requestId);
  }

  void filterByGender(GenderFilter filter) {
    switch (state) {
      case FeedInitialState(): return;
      case FeedInitialLoadingState s: emit(s.copyWith(activeFilter: filter));
      case FeedFailureState s: emit(s.copyWith(activeFilter: filter));
      case FeedReloadingState s: emit(s.copyWith(activeFilter: filter, displayedItems: _filter.apply(s.allItems, filter)));
      case FeedSuccessState s: emit(s.copyWith(activeFilter: filter, displayedItems: _filter.apply(s.allItems, filter)));
    }
  }

  Future<void> _loadFeed({
    required FeedSource source,
    required GenderFilter filter,
    required int requestId,
  }) async {
    final feedResult = await _repository.getFeed(source: source);

    // Guard against stale responses: if a newer request was started
    // (e.g. source switched) while this one was in-flight, discard the result.
    if (requestId != _requestId) return;

    switch (feedResult) {
      case Cancelled():
        return;
      case Failure(:final failure):
        emit(FeedFailureState(failure: failure, activeSource: source, activeFilter: filter));
        return;
      case Success(:final value):
        final feedItems = value;
        _emitSuccess(feedItems, source: source, filter: filter);

        final brandSliders = feedItems.whereType<BrandSliderModel>().toList();
        if (brandSliders.isEmpty) return;

        // Load all brand sliders in parallel. Dart's single-threaded event loop
        // ensures updates to [currentItems] are always serialized — no concurrent
        // write conflicts. Each result emits immediately for progressive UI updates.
        var currentItems = feedItems;
        await Future.wait(
          brandSliders.map((brandSlider) async {
            final brandResult = await _repository.loadBrandItems(itemsUrl: brandSlider.itemsUrl);

            switch (brandResult) {
              case Cancelled():
                return;
              case Failure():
              case Success(value: []):
                // Remove the slider if loading failed or all sub-items were unparseable.
                currentItems = currentItems.where((item) => item.id != brandSlider.id).toList();
                _emitSuccess(currentItems, source: source, filter: filter);
              case Success(:final value):
                currentItems = currentItems
                    .map((item) => item.id == brandSlider.id
                        ? brandSlider.copyWithSubItems(value)
                        : item)
                    .toList();
                _emitSuccess(currentItems, source: source, filter: filter);
            }
          }),
        );
    }
  }

  void _emitSuccess(
    List<FeedItem> items, {
    required FeedSource source,
    required GenderFilter filter,
  }) {
    emit(FeedSuccessState(
      allItems: items,
      displayedItems: _filter.apply(items, filter),
      activeSource: source,
      activeFilter: filter,
    ));
  }

  @override
  Future<void> close() {
    _repository.cancel();
    return super.close();
  }
}
