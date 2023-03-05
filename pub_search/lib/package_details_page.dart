import 'package:flutter/material.dart';

class PackageDetailsPage extends StatelessWidget {
  const PackageDetailsPage({super.key, required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(packageName),
      ),
    );
  }
}
