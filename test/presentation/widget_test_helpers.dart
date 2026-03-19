import 'package:coding_challenge/application/feed_cubit/feed_cubit.dart';
import 'package:coding_challenge/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildTestWidget(
  FeedCubit cubit,
  Widget child, {
  bool withScaffold = true,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<FeedCubit>.value(
      value: cubit,
      child: withScaffold ? Scaffold(body: child) : child,
    ),
  );
}

Widget buildWithSize(FeedCubit cubit, Widget child, Size size) {
  return buildTestWidget(
    cubit,
    MediaQuery(
      data: MediaQueryData(size: size),
      child: child,
    ),
    withScaffold: false,
  );
}
