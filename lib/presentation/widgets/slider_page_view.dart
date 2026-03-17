import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/slider_sub_item_page.dart';
import 'package:flutter/material.dart';

class SliderPageView extends StatelessWidget {
  const SliderPageView({required this.subItems, super.key});

  final List<SliderSubItemModel> subItems;

  @override
  Widget build(BuildContext context) {
    if (subItems.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 240,
      child: PageView.builder(
        itemCount: subItems.length,
        itemBuilder: (context, index) =>
            SliderSubItemPage(subItem: subItems[index]),
      ),
    );
  }
}
