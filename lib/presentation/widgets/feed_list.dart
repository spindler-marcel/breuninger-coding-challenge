import 'package:coding_challenge/data/feed_list_changes.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/animated_feed_item.dart';
import 'package:flutter/material.dart';

class FeedList extends StatefulWidget {
  const FeedList({required this.items, super.key});

  final List<FeedItem> items;

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<FeedItem> _currentItems;

  @override
  void initState() {
    super.initState();
    _currentItems = List.of(widget.items);
  }

  @override
  void didUpdateWidget(FeedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _applyChanges(widget.items);
    }
  }

  void _applyChanges(List<FeedItem> newItems) {
    const duration = Duration(milliseconds: 300);

    final changes = FeedListChanges.between(
      oldItems: _currentItems,
      newItems: newItems,
    );

    if (changes.isEmpty) {
      _currentItems = List.of(newItems);
      return;
    }

    // Remove — iterate in reverse to keep indices stable
    for (final id in changes.removed.reversed) {
      final index = _currentItems.indexWhere((item) => item.id == id);
      if (index == -1) continue;
      final removed = _currentItems.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => AnimatedFeedItem(item: removed, animation: animation),
        duration: duration,
      );
    }

    if (changes.added.isEmpty) {
      _currentItems = List.of(newItems);
      return;
    }

    void insertItems() {
      if (!mounted) return;
      for (final newItem in newItems) {
        if (!changes.added.contains(newItem.id)) continue;
        final index = newItems.indexOf(newItem);
        _currentItems.insert(index, newItem);
        _listKey.currentState?.insertItem(index, duration: duration);
      }
      _currentItems = List.of(newItems);
    }

    if (changes.removed.isEmpty) {
      insertItems();
    } else {
      Future.delayed(duration, insertItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      padding: const EdgeInsets.symmetric(vertical: 8),
      initialItemCount: _currentItems.length,
      itemBuilder: (context, index, animation) => AnimatedFeedItem(
        item: _currentItems[index],
        animation: animation,
      ),
    );
  }
}
