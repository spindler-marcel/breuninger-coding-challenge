import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/adaptive_refresh_scroll_view.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/animated_feed_item.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/feed_animation_mixin.dart';
import 'package:flutter/material.dart';

class FeedGridContent extends StatefulWidget {
  const FeedGridContent({required this.items, this.onRefresh, super.key});

  final List<FeedItem> items;
  final RefreshCallback? onRefresh;

  @override
  State<FeedGridContent> createState() => _FeedGridContentState();
}

class _FeedGridContentState extends State<FeedGridContent>
    with FeedAnimationMixin<FeedGridContent> {
  final _gridKey = GlobalKey<SliverAnimatedGridState>();

  @override
  void initState() {
    super.initState();
    initItems(widget.items);
  }

  @override
  void didUpdateWidget(FeedGridContent old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) applyChanges(widget.items);
  }

  @override
  void insertAnimatedItem(int index, Duration duration) {
    _gridKey.currentState?.insertItem(index, duration: duration);
  }

  @override
  void removeAnimatedItem(
    int index,
    Widget Function(BuildContext, Animation<double>) builder,
    Duration duration,
  ) {
    _gridKey.currentState?.removeItem(index, builder, duration: duration);
  }

  @override
  Widget buildRemovedItem(FeedItem item, Animation<double> animation) {
    return AnimatedFeedItem(item: item, animation: animation);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return AdaptiveRefreshScrollView(
      onRefresh: widget.onRefresh,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(top: 8, bottom: 8 + bottomPadding),
          sliver: SliverAnimatedGrid(
            key: _gridKey,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisExtent: 290,
            ),
            initialItemCount: currentItems.length,
            itemBuilder: (context, index, animation) => AnimatedFeedItem(
              item: currentItems[index],
              animation: animation,
            ),
          ),
        ),
      ],
    );
  }
}
