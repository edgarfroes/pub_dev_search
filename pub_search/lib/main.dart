import 'package:flutter/material.dart';
import 'package:pub_search/theme.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter package search',
      theme: mainTheme,
      home: const HomePage(),
    );
  }
}
