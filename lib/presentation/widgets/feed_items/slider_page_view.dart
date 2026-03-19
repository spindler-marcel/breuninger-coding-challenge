import 'package:coding_challenge/presentation/feed_dimensions.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/slider_sub_item_page.dart';
import 'package:flutter/material.dart';

class SliderPageView extends StatefulWidget {
  const SliderPageView({required this.subItems, super.key});

  final List<SliderSubItemModel> subItems;

  @override
  State<SliderPageView> createState() => _SliderPageViewState();
}

class _SliderPageViewState extends State<SliderPageView> {
  final _padEndsTarget = FeedDimensions.horizontalMargin - FeedDimensions.sliderSubItemHorizontalMargin;

  PageController? _controller;
  int _currentPage = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final vp = MediaQuery.sizeOf(context).width;
      final fraction = 1.0 - 2 * _padEndsTarget / vp;
      _controller = PageController(viewportFraction: fraction);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subItems.isEmpty) return const SizedBox.shrink();

    final hasMultipleItems = widget.subItems.length > 1;
    const dotsHeight = FeedDimensions.sliderDotsHeight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FeedDimensions.verticalMargin),
      child: LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : (hasMultipleItems ? FeedDimensions.sliderHeightWithDots : FeedDimensions.sliderHeightWithoutDots);
        final pageViewHeight = totalHeight - (hasMultipleItems ? dotsHeight : 0);

        return SizedBox(
        height: totalHeight,
        child: Column(
          children: [
            SizedBox(
              height: pageViewHeight,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.subItems.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => SliderSubItemPage(
                  subItem: widget.subItems[index],
                  controller: _controller!,
                  index: index,
                ),
              ),
            ),
            if (hasMultipleItems) SizedBox(height: dotsHeight / 2),
            if (hasMultipleItems) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.subItems.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == index ? 16 : 8,
                  height: dotsHeight / 2,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        );
      },
      ),
    );
  }
}
