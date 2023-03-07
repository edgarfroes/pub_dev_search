import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/loading_indicator.dart';
import '../../../widgets/package_button.dart';
import '../../../widgets/rounded_container.dart';
import 'search_packages_results_controller.dart';

class SearchPackagesResults extends GetView<SearchPackagesResultsController> {
  const SearchPackagesResults({
    super.key,
    required this.onSelectPackage,
  });

  final Function(String) onSelectPackage;

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) {
        return RoundedContainer(
          child: Column(
            children: state?.map(
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
                ).toList() ??
                [],
          ),
        );
      },
      onLoading: const LoadingIndicator(),
      onEmpty: const RoundedContainer(
        child: Text(
          'No packages found',
          textAlign: TextAlign.center,
        ),
      ),
      onError: (error) => RoundedContainer(
        child: Text(
          error ?? 'Error searching packages',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
