import 'package:coding_challenge/injection_container.dart';
import 'package:coding_challenge/presentation/pages/feed_page.dart';
import 'package:flutter/material.dart';

void main() {
  initDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const FeedPage(),
    );
  }
}
