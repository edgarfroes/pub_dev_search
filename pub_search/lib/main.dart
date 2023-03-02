import 'package:flutter/material.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_search/theme.dart';

import 'search_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter package search',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(title: 'Flutter package search'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textFieldController = TextEditingController();
  final _textFieldFocusNode = FocusNode();

  final client = PubClient();

  final _packages = <PackageResult>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              SearchTextField(
                controller: _textFieldController,
                focusNode: _textFieldFocusNode,
                onChanged: (value) async {
                  if (value.length >= 2) {
                    final searchResults = await client.search(value);

                    setState(() {
                      _packages.clear();
                      _packages.addAll(searchResults.packages.take(5));
                    });

                    return;
                  }

                  setState(() {
                    _packages.clear();
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              if (_packages.isEmpty && _textFieldController.text.length >= 2)
                const Text(
                  'No packages found',
                  style: TextStyle(
                    color: foregroundColor,
                  ),
                ),
              ..._packages.map(
                (x) => Text(
                  x.package,
                  style: const TextStyle(
                    color: foregroundColor,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  _textFieldController.clear();
                  _packages.clear();
                  _textFieldFocusNode.unfocus();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.clear,
                      color: foregroundColor,
                    ),
                    Text(
                      'Clear all data',
                      style: TextStyle(
                        color: foregroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
