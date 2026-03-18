import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReloadingIndicator extends StatelessWidget {
  const ReloadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      buildWhen: (prev, curr) =>
          (prev is FeedReloadingState && !prev.isPullToRefresh) !=
          (curr is FeedReloadingState && !curr.isPullToRefresh),
      builder: (context, state) {
        final isReloading =
            state is FeedReloadingState && !state.isPullToRefresh;
        return AnimatedOpacity(
          opacity: isReloading ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}
