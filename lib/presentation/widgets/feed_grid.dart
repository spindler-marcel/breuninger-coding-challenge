import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:coding_challenge/presentation/widgets/feed_grid_content.dart';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late List<FeedItem> _displayedItems;
  late GenderFilter _activeFilter;

  // Holds the latest target state while a fade-out is in progress.
  List<FeedItem>? _pendingItems;
  GenderFilter? _pendingFilter;

  @override
  void initState() {
    super.initState();
    _displayedItems = widget.items;
    _activeFilter = widget.activeFilter;
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
  void didUpdateWidget(FeedGrid old) {
    super.didUpdateWidget(old);
    if (old.items == widget.items) return;

    if (old.activeFilter != widget.activeFilter) {
      _fadeTransition(widget.items, widget.activeFilter);
    } else if (_pendingItems != null) {
      // A filter fade is already in progress: update pending items so the
      // new content is initialized with the latest data when it mounts.
      _pendingItems = widget.items;
    } else {
      // Same filter, no fade in progress: pass new items to FeedGridContent
      // for individual insert/remove animations via its didUpdateWidget.
      setState(() => _displayedItems = widget.items);
    }
  }

  /// Fades the grid out, swaps content (via [ValueKey] on [FeedGridContent]),
  /// then fades back in. If a new filter arrives while the fade-out is still
  /// running, only the pending target is updated — the in-progress animation
  /// picks up the latest state when it completes.
  void _fadeTransition(List<FeedItem> newItems, GenderFilter newFilter) {
    _pendingItems = newItems;
    _pendingFilter = newFilter;
    if (_fadeController.isAnimating && _fadeController.velocity < 0) return;

    _fadeController.reverse().then((_) {
      if (!mounted || _pendingItems == null) return;
      setState(() {
        _displayedItems = List.of(_pendingItems!);
        _activeFilter = _pendingFilter!;
        _pendingItems = null;
        _pendingFilter = null;
      });
      _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: FeedGridContent(
        key: ValueKey(_activeFilter),
        items: _displayedItems,
        onRefresh: widget.onRefresh,
      ),
    );
  }
}
