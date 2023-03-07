import 'package:flutter/material.dart';

class PackageStatistic extends StatelessWidget {
  const PackageStatistic({
    super.key,
    required this.value,
    required this.description,
  });

  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
