import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/adaptive_refresh_scroll_view.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/animated_feed_item.dart';
import 'package:coding_challenge/presentation/widgets/feed_items/feed_animation_mixin.dart';
import 'package:flutter/material.dart';

class FeedGrid extends StatefulWidget {
  const FeedGrid({
    required this.items,
    required this.activeFilter,
    this.onRefresh,
    super.key,
  });

  final List<FeedItem> items;
  final GenderFilter activeFilter;
  final RefreshCallback? onRefresh;

  @override
  State<FeedGrid> createState() => _FeedGridState();
}

class _FeedGridState extends State<FeedGrid>
    with FeedAnimationMixin<FeedGrid>, SingleTickerProviderStateMixin {
  GlobalKey<SliverAnimatedGridState> _gridKey = GlobalKey();

  late AnimationController _fadeController;
  List<FeedItem>? _pendingFadeItems;

  @override
  void initState() {
    super.initState();
    initItems(widget.items);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FeedGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items == widget.items) return;

    if (oldWidget.activeFilter != widget.activeFilter) {
      _fadeTransition(widget.items);
    } else {
      applyChanges(widget.items);
    }
  }

  /// Fades the grid out, swaps all items, then fades back in.
  /// [_pendingFadeItems] always holds the latest target list. If a new filter
  /// arrives while the fade-out is still running, we skip starting another
  /// reverse animation and just update the pending items — the in-progress
  /// fade-out will pick up the latest list when it completes.
  /// A new [GlobalKey] forces [SliverAnimatedGrid] to rebuild from scratch
  /// with [initialItemCount], since all items are replaced at once.
  void _fadeTransition(List<FeedItem> newItems) {
    _pendingFadeItems = newItems;
    if (_fadeController.isAnimating && _fadeController.velocity < 0) return;

    _fadeController.reverse().then((_) {
      if (!mounted || _pendingFadeItems == null) return;
      setState(() {
        currentItems = List.of(_pendingFadeItems!);
        _pendingFadeItems = null;
        _gridKey = GlobalKey();
      });
      _fadeController.forward();
    });
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

    return FadeTransition(
      opacity: _fadeController,
      child: AdaptiveRefreshScrollView(
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
      ),
    );
  }
}
