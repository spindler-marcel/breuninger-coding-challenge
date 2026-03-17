import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderFilterBar extends StatelessWidget {
  const GenderFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        final activeFilter =
            state is FeedSuccessState ? state.activeFilter : GenderFilter.all;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: GenderFilter.values
                .map(
                  (filter) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(filter.name.toUpperCase()),
                      selected: activeFilter == filter,
                      onSelected: (_) =>
                          context.read<FeedCubit>().filterByGender(filter),
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
