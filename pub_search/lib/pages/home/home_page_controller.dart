import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/local_storage_service.dart';
import '../../services/pub_service.dart';
import 'recent_searches/recent_searches_controller.dart';
import 'search_packages/search_packages_results_controller.dart';

class HomePageController extends GetxController {
  final textFieldController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  late final RecentSearchesController recentSearchesController;
  late final SearchPackagesResultsController searchPackagesResultsController;

  final isInSearchingMode = false.obs;

  final foundPackages = RxList<String>();

  @override
  void onInit() {
    super.onInit();

    _initDependencies();

    textFieldController.addListener(_updateSearchingMode);
  }

  void _initDependencies() {
    recentSearchesController = Get.put(
      RecentSearchesController(
        localStorageService: Get.find<LocalStorageService>(),
      ),
    );

    searchPackagesResultsController = Get.put(
      SearchPackagesResultsController(
        pubService: Get.find<PubService>(),
      ),
    );
  }

  void _updateSearchingMode() {
    isInSearchingMode.value = textFieldController.text.length >= 2;
  }

  searchPackages(String term) async {
    if (!isInSearchingMode.value) {
      return;
    }

    searchPackagesResultsController.search(term);
  }

  Future goToPackageDetailsPage(String packageName) async {
    await Get.toNamed(
      '/details',
      arguments: {
        'packageName': packageName,
      },
    );

    await Future.delayed(const Duration(milliseconds: 500));

    textFieldFocusNode.unfocus();
    textFieldController.clear();
    recentSearchesController.save(packageName);
  }

  clear() async {
    textFieldController.clear();
    textFieldFocusNode.unfocus();

    searchPackagesResultsController.clear();
    recentSearchesController.clear();

    recentSearchesController.getRecentSearches();
  }
}
