import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/core/extensions/feed_source_l10n.dart';
import 'package:coding_challenge/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SourceToggle extends StatelessWidget {
  const SourceToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        final activeSource = switch (state) {
          FeedSuccessState s => s.activeSource,
          FeedInitialLoadingState s => s.activeSource,
          FeedFailureState s => s.activeSource,
          _ => FeedSource.source1,
        };
        final selectedIndex = FeedSource.values.indexOf(activeSource);
        final segmentCount = FeedSource.values.length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Stack(
                  children: [
                    // Sliding pill
                    Positioned.fill(
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: Alignment(
                          -1.0 + selectedIndex * (2.0 / (segmentCount - 1)),
                          0,
                        ),
                        child: FractionallySizedBox(
                          widthFactor: 1 / segmentCount,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Labels
                    Row(
                      children: FeedSource.values.map((source) {
                        final isSelected = source == activeSource;
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => BlocProvider.of<FeedCubit>(context)
                                .switchSource(source),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 7),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                                child: Text(
                                  source.label(AppLocalizations.of(context)!),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
