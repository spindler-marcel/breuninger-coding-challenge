import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/core/failures/app_failure_mapper.dart';
import 'package:coding_challenge/l10n/app_localizations.dart';
import 'package:coding_challenge/presentation/widgets/feed_list.dart';
import 'package:coding_challenge/presentation/widgets/gender_filter_bar.dart';
import 'package:coding_challenge/presentation/widgets/source_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.feed_title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          BlocBuilder<FeedCubit, FeedState>(
            buildWhen: (prev, curr) =>
                (prev is FeedReloadingState && !prev.isPullToRefresh) !=
                (curr is FeedReloadingState && !curr.isPullToRefresh),
            builder: (context, state) {
              final isReloading =
                  state is FeedReloadingState && !state.isPullToRefresh;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: isReloading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const SizedBox(width: 16),
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(96),
          child: Column(children: [SourceToggle(), GenderFilterBar()]),
        ),
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state is FeedInitialLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FeedSuccessState || state is FeedReloadingState) {
            final items = state is FeedSuccessState
                ? state.displayedItems
                : (state as FeedReloadingState).displayedItems;
            return FeedList(
              items: items,
              onRefresh: () => BlocProvider.of<FeedCubit>(context).refresh(),
            );
          }
          if (state is FeedFailureState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppFailureMapper.map(state.failure, l10n),
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          BlocProvider.of<FeedCubit>(context).refresh(),
                      child: Text(l10n.feed_error_retry),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// TODO: LOGIK AUS WIDGETS ENTFERNEN
// TODO: GRID BEI TABLET
// TODO: ORDNER STRUKTURIEREN
// TODO: TEST MIT LANGSAMEN INTERNET
// TODO: UNIT TESTS
// TODO: WIDGET TESTS
