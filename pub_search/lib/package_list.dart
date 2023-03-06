import 'package:flutter/material.dart';

import 'package_button.dart';
import 'rounded_container.dart';

class PackageList extends StatelessWidget {
  const PackageList({
    super.key,
    this.title,
    this.onSelectPackage,
    required this.packages,
  });

  final String? title;
  final List<String> packages;
  final Function(String)? onSelectPackage;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      child: Column(
        children: [
          if (title?.isNotEmpty == true)
            Column(
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  alignment: Alignment.center,
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider()
              ],
            ),
          ...packages.map(
            (packageName) {
              return Column(
                children: [
                  PackageButton(
                    packageName: packageName,
                    onPressed: () => onSelectPackage?.call(packageName),
                  ),
                  if (packageName != packages.last) const Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
