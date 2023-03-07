import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/loading_indicator.dart';
import '../../../widgets/package_button.dart';
import '../../../widgets/rounded_container.dart';
import 'recent_searches_controller.dart';

class RecentSearches extends GetView<RecentSearchesController> {
  const RecentSearches({
    super.key,
    required this.onSelectPackage,
  });

  final Function(String) onSelectPackage;

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) => RoundedContainer(
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 48),
              alignment: Alignment.center,
              child: const Text(
                'Recent Searches',
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),
            if (state != null)
              ...state.map(
                (packageName) {
                  return Column(
                    children: [
                      PackageButton(
                        packageName: packageName,
                        onPressed: () => onSelectPackage(packageName),
                      ),
                      if (packageName != state.last) const Divider(),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
      onLoading: const LoadingIndicator(),
      onEmpty: const RoundedContainer(
        child: Text(
          'No Recent Searches',
          textAlign: TextAlign.center,
        ),
      ),
      onError: (error) => RoundedContainer(
        child: Text(
          error ?? 'Error fetching recent packages',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
