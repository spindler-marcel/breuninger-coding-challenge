import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/brand_slider_card.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/slider_card.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/teaser_card.dart';
import 'package:flutter/material.dart';

class AnimatedFeedGridItem extends StatelessWidget {
  const AnimatedFeedGridItem({
    required this.item,
    required this.animation,
    super.key,
  });

  final FeedItem item;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: switch (item) {
          TeaserModel teaser => TeaserCard(teaser: teaser),
          SliderModel slider => SliderCard(slider: slider),
          BrandSliderModel brandSlider => BrandSliderCard(brandSlider: brandSlider),
        },
      ),
    );
  }
}
