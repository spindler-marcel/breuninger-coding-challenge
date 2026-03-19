import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/data/models/feed_models.dart';

class FeedFilter {
  List<FeedItem> apply(List<FeedItem> items, GenderFilter filter) {
    return items
        .map<FeedItem?>(
          (item) => switch (item) {
            TeaserModel teaser => _filterTeaser(teaser, filter),
            SliderModel slider => _filterSlider(slider, filter),
            BrandSliderModel brandSlider => _filterBrandSlider(
              brandSlider,
              filter,
            ),
          },
        )
        .nonNulls
        .toList();
  }

  TeaserModel? _filterTeaser(TeaserModel teaser, GenderFilter filter) {
    if (filter == GenderFilter.all) return teaser;
    if (teaser.gender == null) return null;
    return teaser.gender == filter.name ? teaser : null;
  }

  SliderModel? _filterSlider(SliderModel slider, GenderFilter filter) {
    if (filter == GenderFilter.all) {
      return slider.subItems.isEmpty ? null : slider;
    }
    final matching = slider.subItems
        .where((item) => item.gender == filter.name)
        .toList();
    if (matching.isEmpty) return null;
    return SliderModel(id: slider.id, subItems: matching);
  }

  BrandSliderModel? _filterBrandSlider(
    BrandSliderModel brandSlider,
    GenderFilter filter,
  ) {
    if (brandSlider.subItems == null) return brandSlider;
    if (filter == GenderFilter.all) {
      return brandSlider.subItems!.isEmpty ? null : brandSlider;
    }
    final matching = brandSlider.subItems!
        .where((item) => item.gender == filter.name)
        .toList();
    if (matching.isEmpty) return null;
    return brandSlider.copyWithSubItems(matching);
  }
}
