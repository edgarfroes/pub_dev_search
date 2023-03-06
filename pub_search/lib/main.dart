import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pub_search/theme.dart';

import 'home_page.dart';

Future<void> main() async {
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _DismissKeyboardOnTapOutsideTextField(
      child: MaterialApp(
        title: 'Flutter package search',
        theme: mainTheme,
        home: const HomePage(),
      ),
    );
  }
}

class _DismissKeyboardOnTapOutsideTextField extends StatelessWidget {
  final Widget child;
  const _DismissKeyboardOnTapOutsideTextField({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        FocusScope.of(context).unfocus();

        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
