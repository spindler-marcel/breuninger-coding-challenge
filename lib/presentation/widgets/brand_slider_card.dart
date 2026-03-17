import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/slider_page_view.dart';
import 'package:flutter/material.dart';

class BrandSliderCard extends StatelessWidget {
  const BrandSliderCard({required this.brandSlider, super.key});

  final BrandSliderModel brandSlider;

  @override
  Widget build(BuildContext context) {
    final subItems = brandSlider.subItems;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: subItems == null
          ? const SizedBox(
              key: ValueKey('loading'),
              height: 240,
              child: Center(child: CircularProgressIndicator()),
            )
          : SliderPageView(
              key: ValueKey(brandSlider),
              subItems: subItems,
            ),
    );
  }
}
