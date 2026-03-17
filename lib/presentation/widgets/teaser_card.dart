import 'package:cached_network_image/cached_network_image.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeaserCard extends StatelessWidget {
  const TeaserCard({required this.teaser, super.key});

  final TeaserModel teaser;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            imageUrl: teaser.imageUrl ?? '',
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
            errorWidget: (context, url, error) =>
                const SizedBox(height: 200, child: Icon(Icons.broken_image)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (teaser.headline != null) ...[
                  Text(teaser.headline!, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                ],
                TextButton(
                  onPressed: () => launchUrl(Uri.parse(teaser.url)),
                  child: const Text('Read more'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
