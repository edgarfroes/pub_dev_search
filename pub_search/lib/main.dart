import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pub_search/theme.dart';

import 'pages/details_page.dart';
import 'pages/home/home_page.dart';
import 'services/local_storage_service.dart';
import 'services/pub_service.dart';

Future<void> main() async {
  await _injectDependencies();

  runApp(const MyApp());
}

Future<void> _injectDependencies() async {
  Get.put(LocalStorageService(storage: GetStorage()));
  Get.put(PubService(client: PubClient()));
  await Get.find<LocalStorageService>().init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _DismissKeyboardOnTapOutsideTextField(
      child: GetMaterialApp(
        title: 'Flutter package search',
        theme: mainTheme,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const HomePage()),
          GetPage(name: '/details', page: () => const DetailsPage()),
        ],
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
