import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/presentation/widgets/feed_list.dart';
import 'package:coding_challenge/presentation/widgets/gender_filter_bar.dart';
import 'package:coding_challenge/presentation/widgets/source_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(96),
          child: Column(children: [SourceToggle(), GenderFilterBar()]),
        ),
      ),
      body: BlocConsumer<FeedCubit, FeedState>(
        listener: (context, state) {
          if (state is FeedFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is FeedLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FeedSuccessState) {
            return RefreshIndicator(
              onRefresh: () => context.read<FeedCubit>().refresh(),
              child: FeedList(items: state.displayedItems),
            );
          }
          if (state is FeedFailureState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<FeedCubit>().refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// TODO: WECHSEL ANIMATION SELTSAM
// TODO: SLIDER SOLL INDICATOR FÜR MENGE DER ELEMENTE HABEN UND NÄCHSTES ELEMENT SOLL ETWAS SICHTBAR SEIN
// TODO: THEME
// TODO: LOCALIZATION
// TODO: DESIGN ERSTELLEN LASSEN UXPILOT. CLAUDE SOLL PROMPT SCHREIBEN
// TODO: ANIMATIONEN
// TODO: UNIT TESTS
// TODO: WIDGET TESTS
