import 'package:coding_challenge/data/models/feed_models.dart';

class FeedListChanges {
  const FeedListChanges({required this.added, required this.removed});

  final List<int> added;
  final List<int> removed;

  factory FeedListChanges.between({
    required List<FeedItem> oldItems,
    required List<FeedItem> newItems,
  }) {
    final oldIds = oldItems.map((item) => item.id).toSet();
    final newIds = newItems.map((item) => item.id).toSet();
    return FeedListChanges(
      added: newIds.difference(oldIds).toList(),
      removed: oldIds.difference(newIds).toList(),
    );
  }

  bool get isEmpty => added.isEmpty && removed.isEmpty;
}
