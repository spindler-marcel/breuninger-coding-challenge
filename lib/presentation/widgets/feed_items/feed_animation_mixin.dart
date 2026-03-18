import 'package:coding_challenge/data/feed_list_changes.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter/material.dart';

mixin FeedAnimationMixin<T extends StatefulWidget> on State<T> {
  late List<FeedItem> currentItems;

  void initItems(List<FeedItem> items) {
    currentItems = List.of(items);
  }

  void insertAnimatedItem(int index, Duration duration);

  void removeAnimatedItem(
    int index,
    Widget Function(BuildContext, Animation<double>) builder,
    Duration duration,
  );

  Widget buildRemovedItem(FeedItem item, Animation<double> animation);

  void applyChanges(List<FeedItem> newItems) {
    const duration = Duration(milliseconds: 300);

    final changes = FeedListChanges.between(
      oldItems: currentItems,
      newItems: newItems,
    );

    if (changes.isEmpty) {
      currentItems = List.of(newItems);
      return;
    }

    final idToIndex = <int, int>{
      for (var i = 0; i < currentItems.length; i++) currentItems[i].id: i,
    };

    final indicesToRemove = changes.removed
        .map((id) => idToIndex[id])
        .whereType<int>()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    for (final index in indicesToRemove) {
      final removed = currentItems.removeAt(index);
      removeAnimatedItem(
        index,
        (context, animation) => buildRemovedItem(removed, animation),
        duration,
      );
    }

    if (changes.added.isEmpty) {
      currentItems = List.of(newItems);
      return;
    }

    final addedIds = changes.added.toSet();

    if (changes.removed.isEmpty) {
      _insertItems(newItems, addedIds, duration);
    } else {
      Future.delayed(duration, () => _insertItems(newItems, addedIds, duration));
    }
  }

  void _insertItems(List<FeedItem> newItems, Set<int> addedIds, Duration duration) {
    if (!mounted) return;
    for (var i = 0; i < newItems.length; i++) {
      final item = newItems[i];
      if (!addedIds.contains(item.id)) continue;
      currentItems.insert(i, item);
      insertAnimatedItem(i, duration);
    }
    currentItems = List.of(newItems);
  }
}
