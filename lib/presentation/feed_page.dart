import 'package:coding_challenge/core/app_theme.dart';
import 'package:coding_challenge/injection_container.dart';
import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/presentation/widgets/feed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient = Theme.of(context).extension<AppGradients>()!.background;

    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: BlocProvider(
        create: (_) => sl<FeedCubit>()..refresh(),
        child: const FeedView(),
      ),
    );
  }
}
