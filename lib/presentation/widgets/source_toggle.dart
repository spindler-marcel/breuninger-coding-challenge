import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SourceToggle extends StatelessWidget {
  const SourceToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        final activeSource =
            state is FeedSuccessState ? state.activeSource : FeedSource.source1;

        return SegmentedButton<FeedSource>(
          segments: const [
            ButtonSegment(
              value: FeedSource.source1,
              label: Text('Source 1'),
            ),
            ButtonSegment(
              value: FeedSource.source2,
              label: Text('Source 2'),
            ),
          ],
          selected: {activeSource},
          onSelectionChanged: (selection) =>
              context.read<FeedCubit>().switchSource(selection.first),
        );
      },
    );
  }
}
