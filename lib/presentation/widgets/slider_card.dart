import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/slider_page_view.dart';
import 'package:flutter/material.dart';

class SliderCard extends StatelessWidget {
  const SliderCard({required this.slider, super.key});

  final SliderModel slider;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: SliderPageView(
        key: ValueKey(slider),
        subItems: slider.subItems,
      ),
    );
  }
}
