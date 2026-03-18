import 'package:coding_challenge/core/feed_margins.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/slider_sub_item_page.dart';
import 'package:flutter/material.dart';

class SliderPageView extends StatefulWidget {
  const SliderPageView({required this.subItems, super.key});

  final List<SliderSubItemModel> subItems;

  @override
  State<SliderPageView> createState() => _SliderPageViewState();
}

class _SliderPageViewState extends State<SliderPageView> {
  final _padEndsTarget = FeedMargins.horizontal - FeedMargins.sliderSubItemHorizontal;

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FeedMargins.vertical),
      child: SizedBox(
      height: 264,
      child: Column(
        children: [
          SizedBox(
            height: 240,
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
          const SizedBox(height: 8),
          if (widget.subItems.length > 1) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.subItems.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 16 : 8,
                height: 8,
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
      ),
    );
  }
}
