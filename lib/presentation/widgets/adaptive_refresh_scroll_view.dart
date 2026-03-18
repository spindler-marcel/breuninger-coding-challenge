import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdaptiveRefreshScrollView extends StatelessWidget {
  const AdaptiveRefreshScrollView({
    required this.slivers,
    this.onRefresh,
    super.key,
  });

  final List<Widget> slivers;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final effectiveSlivers = [
      if (onRefresh != null && defaultTargetPlatform == TargetPlatform.iOS)
        CupertinoSliverRefreshControl(
          onRefresh: onRefresh,
          refreshTriggerPullDistance: 80.0,
          refreshIndicatorExtent: 40.0,
        ),
      ...slivers,
    ];

    final scrollView = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: effectiveSlivers,
    );

    if (onRefresh != null && defaultTargetPlatform != TargetPlatform.iOS) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: scrollView,
      );
    }

    return scrollView;
  }
}
