import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/core/extensions/gender_filter_l10n.dart';
import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderFilterBar extends StatelessWidget {
  const GenderFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      buildWhen: (prev, curr) => prev.activeFilter != curr.activeFilter,
      builder: (context, state) {
        final activeFilter = state.activeFilter;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: GenderFilter.values
                .map(
                  (filter) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(filter.label(AppLocalizations.of(context)!)),
                      selected: activeFilter == filter,
                      onSelected: (_) =>
                          BlocProvider.of<FeedCubit>(context).filterByGender(filter),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
