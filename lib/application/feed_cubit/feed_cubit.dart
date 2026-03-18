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
    final (source, filter) = switch (currentState) {
      FeedSuccessState s => (s.activeSource, s.activeFilter),
      FeedFailureState s => (s.activeSource, s.activeFilter),
      FeedInitialLoadingState s => (s.activeSource, s.activeFilter),
      _ => (FeedSource.source1, GenderFilter.all),
    };
    _repository.cancel();
    final requestId = ++_requestId;
    if (currentState is FeedSuccessState) {
      emit(currentState.copyWith(isReloading: true));
    } else {
      emit(FeedInitialLoadingState(activeSource: source, activeFilter: filter));
    }
    await _loadFeed(source: source, filter: filter, requestId: requestId);
  }

  Future<void> switchSource(FeedSource source) async {
    if (state case FeedSuccessState s when s.activeSource == source) return;

    final currentState = state;
    final filter = currentState is FeedSuccessState
        ? currentState.activeFilter
        : GenderFilter.all;

    _repository.cancel();
    final requestId = ++_requestId;
    if (currentState is FeedSuccessState) {
      emit(currentState.copyWith(activeSource: source, activeFilter: filter, isReloading: true));
    } else {
      emit(FeedInitialLoadingState(activeSource: source, activeFilter: filter));
    }
    await _loadFeed(source: source, filter: filter, requestId: requestId);
  }

  void filterByGender(GenderFilter filter) {
    final currentState = state;
    if (currentState is! FeedSuccessState) return;
    emit(FeedSuccessState(
      allItems: currentState.allItems,
      displayedItems: _filter.apply(currentState.allItems, filter),
      activeSource: currentState.activeSource,
      activeFilter: filter,
    ));
  }

  Future<void> _loadFeed({
    required FeedSource source,
    required GenderFilter filter,
    required int requestId,
  }) async {
    final feedResult = await _repository.getFeed(source: source);

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

        final brandSlider = feedItems.whereType<BrandSliderModel>().firstOrNull;
        if (brandSlider == null) return;

        final brandResult = await _repository.loadBrandItems(itemsUrl: brandSlider.itemsUrl);

        switch (brandResult) {
          case Cancelled():
            return;
          case Failure():
            final withoutBrand = feedItems.where((item) => item.id != brandSlider.id).toList();
            _emitSuccess(withoutBrand, source: source, filter: filter);
          case Success(:final value):
            final updatedItems = feedItems
                .map((item) => item.id == brandSlider.id
                    ? brandSlider.copyWithSubItems(value)
                    : item)
                .toList();
            _emitSuccess(updatedItems, source: source, filter: filter);
        }
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
