import 'package:coding_challenge/data/feed_list_changes.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/adaptive_refresh_scroll_view.dart';
import 'package:coding_challenge/presentation/widgets/animated_feed_item.dart';
import 'package:flutter/material.dart';

class FeedList extends StatefulWidget {
  const FeedList({required this.items, this.onRefresh, super.key});

  final List<FeedItem> items;
  final RefreshCallback? onRefresh;

  @override
  State<FeedList> createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  final _listKey = GlobalKey<SliverAnimatedListState>();
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

    final idToIndex = <int, int>{
      for (var i = 0; i < _currentItems.length; i++) _currentItems[i].id: i,
    };

    final indicesToRemove = changes.removed
        .map((id) => idToIndex[id])
        .whereType<int>()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    for (final index in indicesToRemove) {
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
      _currentItems.insert(i, item);
      _listKey.currentState?.insertItem(i, duration: duration);
    }
    _currentItems = List.of(newItems);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return AdaptiveRefreshScrollView(
      onRefresh: widget.onRefresh,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(top: 8, bottom: 8 + bottomPadding),
          sliver: SliverAnimatedList(
            key: _listKey,
            initialItemCount: _currentItems.length,
            itemBuilder: (context, index, animation) => AnimatedFeedItem(
              item: _currentItems[index],
              animation: animation,
            ),
          ),
        ),
      ],
    );
  }
}
