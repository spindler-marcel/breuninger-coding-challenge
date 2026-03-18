import 'package:coding_challenge/injection_container.dart';
import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/presentation/widgets/feed_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FeedCubit>()..refresh(),
      child: const FeedView(),
    );
  }
}
