import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/core/failures/app_failure_mapper.dart';
import 'package:coding_challenge/presentation/responsive_breakpoints.dart';
import 'package:coding_challenge/l10n/app_localizations.dart';
import 'package:coding_challenge/presentation/widgets/feed_grid.dart';
import 'package:coding_challenge/presentation/widgets/feed_list.dart';
import 'package:coding_challenge/presentation/widgets/feed_controls/gender_filter_bar.dart';
import 'package:coding_challenge/presentation/widgets/reloading_indicator.dart';
import 'package:coding_challenge/presentation/widgets/feed_controls/source_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet =
        MediaQuery.sizeOf(context).width >= ResponsiveBreakpoints.tablet;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.feed_title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          if (!isTablet)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: ReloadingIndicator(),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Column(
            children: [
              if (isTablet)
                Row(
                  children: const [
                    SizedBox(width: 40),
                    Expanded(child: SourceToggle()),
                    Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: ReloadingIndicator(),
                    ),
                  ],
                )
              else
                const SourceToggle(),
              const GenderFilterBar(),
            ],
          ),
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
            Future<void> onRefresh() =>
                BlocProvider.of<FeedCubit>(context).refresh();
            return isTablet
                ? FeedGrid(
                    items: items,
                    activeFilter: state.activeFilter,
                    onRefresh: onRefresh,
                  )
                : FeedList(items: items, onRefresh: onRefresh);
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
