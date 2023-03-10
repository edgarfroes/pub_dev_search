import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/search_text_field.dart';
import 'home_page_controller.dart';
import 'recent_searches/recent_searches.dart';
import 'search_packages/search_packages_results.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final HomePageController controller = Get.put(
    HomePageController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: SearchTextField(
                        controller: controller.textFieldController,
                        focusNode: controller.textFieldFocusNode,
                        onChanged: controller.searchPackages,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 237),
                        child: Obx(
                          () {
                            if (controller.isInSearchingMode.value) {
                              return SearchPackagesResults(
                                onSelectPackage:
                                    controller.goToPackageDetailsPage,
                              );
                            }

                            return RecentSearches(
                              onSelectPackage:
                                  controller.goToPackageDetailsPage,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  addSemanticIndexes: false,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: TextButton(
                        onPressed: controller.clear,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.clear),
                            Text(
                              'Clear all data',
                            ),
                          ],
                        ),
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
