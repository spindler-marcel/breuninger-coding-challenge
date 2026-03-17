import 'package:cached_network_image/cached_network_image.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SliderSubItemPage extends StatelessWidget {
  const SliderSubItemPage({required this.subItem, super.key});

  final SliderSubItemModel subItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: subItem.imageUrl ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (subItem.headline != null)
                    Expanded(
                      child: Text(
                        subItem.headline!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  TextButton(
                    onPressed: () => launchUrl(Uri.parse(subItem.url)),
                    child: const Text(
                      'Open',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
