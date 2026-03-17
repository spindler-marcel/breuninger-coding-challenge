import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/brand_slider_card.dart';
import 'package:coding_challenge/presentation/widgets/slider_card.dart';
import 'package:coding_challenge/presentation/widgets/teaser_card.dart';
import 'package:flutter/material.dart';

class AnimatedFeedItem extends StatelessWidget {
  const AnimatedFeedItem({
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
