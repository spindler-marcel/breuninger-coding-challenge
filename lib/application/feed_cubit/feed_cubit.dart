import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/exceptions.dart';
import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/data/feed_filter.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/data/repository/feed_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(this._repository) : super(FeedInitialState());

  final FeedRepository _repository;
  final FeedFilter _filter = FeedFilter();
  CancelToken? _cancelToken;

  Future<void> refresh() async {
    FeedSource source = FeedSource.source1;
    GenderFilter filter = GenderFilter.all;

    final currentState = state;
    if (currentState is FeedSuccessState) {
      source = currentState.activeSource;
      filter = currentState.activeFilter;
    }

    await _loadFeed(source: source, filter: filter);
  }

  Future<void> switchSource(FeedSource source) async {
    if (state case FeedSuccessState s when s.activeSource == source) return;

    GenderFilter filter = GenderFilter.all;
    final currentState = state;
    if (currentState is FeedSuccessState) {
      filter = currentState.activeFilter;
    }

    await _loadFeed(source: source, filter: filter);
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
  }) async {
    _cancelToken?.cancel('Superseded');
    _cancelToken = CancelToken();
    final token = _cancelToken!;

    if (state is! FeedSuccessState) emit(FeedLoadingState());

    try {
      final items = await _repository.getFeed(
        source: source,
        cancelToken: token,
      );
      emit(FeedSuccessState(
        allItems: items,
        displayedItems: _filter.apply(items, filter),
        activeSource: source,
        activeFilter: filter,
      ));

      final brandSlider = items.whereType<BrandSliderModel>().firstOrNull;
      if (brandSlider != null) {
        try {
          final subItems = await _repository.loadBrandItems(
            itemsUrl: brandSlider.itemsUrl,
            cancelToken: token,
          );
          final updatedItems = items
              .map((item) => item.id == brandSlider.id
                  ? brandSlider.copyWithSubItems(subItems)
                  : item)
              .toList();
          emit(FeedSuccessState(
            allItems: updatedItems,
            displayedItems: _filter.apply(updatedItems, filter),
            activeSource: source,
            activeFilter: filter,
          ));
        } on DioException catch (e) {
          if (CancelToken.isCancel(e)) return;
          // Remove brand slider from feed on error
          final withoutBrand = items.where((item) => item.id != brandSlider.id).toList();
          emit(FeedSuccessState(
            allItems: withoutBrand,
            displayedItems: _filter.apply(withoutBrand, filter),
            activeSource: source,
            activeFilter: filter,
          ));
        } catch (_) {
          // Remove brand slider from feed on error
          final withoutBrand = items.where((item) => item.id != brandSlider.id).toList();
          emit(FeedSuccessState(
            allItems: withoutBrand,
            displayedItems: _filter.apply(withoutBrand, filter),
            activeSource: source,
            activeFilter: filter,
          ));
        }
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;
      emit(FeedFailureState('Network error. Pull to refresh.'));
    } on NetworkException {
      emit(FeedFailureState('Network error. Pull to refresh.'));
    } catch (_) {
      emit(FeedFailureState('Something went wrong. Pull to refresh.'));
    }
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel('Cubit closed');
    return super.close();
  }
}
