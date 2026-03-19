import 'package:cached_network_image/cached_network_image.dart';
import 'package:coding_challenge/presentation/feed_dimensions.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeaserCard extends StatelessWidget {
  const TeaserCard({required this.teaser, super.key});

  final TeaserModel teaser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(teaser.url)),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: FeedDimensions.horizontalMargin, vertical: FeedDimensions.verticalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              imageUrl: teaser.imageUrl ?? "",
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) =>
                  const SizedBox(height: 200, child: Icon(Icons.broken_image)),
            ),
            if (teaser.headline != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  teaser.headline!.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

