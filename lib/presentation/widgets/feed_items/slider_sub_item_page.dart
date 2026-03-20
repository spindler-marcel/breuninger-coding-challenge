import 'package:coding_challenge/presentation/feed_dimensions.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SliderSubItemPage extends StatelessWidget {
  const SliderSubItemPage({
    required this.subItem,
    required this.controller,
    required this.index,
    super.key,
  });

  final SliderSubItemModel subItem;
  final PageController controller;
  final int index;

  static const _parallaxAmount = 60.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(subItem.url)),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: FeedDimensions.sliderSubItemHorizontalMargin),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final page = controller.hasClients
                    ? (controller.page ?? index.toDouble())
                    : index.toDouble();
                final pageOffset = page - index;
                return Transform.translate(
                  offset: Offset(pageOffset * _parallaxAmount, 0),
                  child: child,
                );
              },
              child: Image.network(
                  subItem.imageUrl ?? "",
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null ? child : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.all(12),
                child: subItem.headline != null
                    ? Text(
                        subItem.headline!.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
