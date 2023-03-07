import 'dart:io';

import 'package:flutter/material.dart';

class PackageButton extends StatefulWidget {
  const PackageButton({
    super.key,
    required this.packageName,
    required this.onPressed,
  });

  final String packageName;
  final VoidCallback onPressed;

  @override
  State<PackageButton> createState() => _PackageButtonState();
}

class _PackageButtonState extends State<PackageButton> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      hitTestBehavior: HitTestBehavior.deferToChild,
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isActive = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isActive = false;
        });
      },
      child: Semantics(
        label: 'Package: ${widget.packageName}',
        child: RawMaterialButton(
          onPressed: widget.onPressed,
          fillColor: _isActive ? theme.primaryColor : theme.primaryColorDark,
          splashColor: theme.primaryColor,
          animationDuration: Duration.zero,
          highlightColor: theme.primaryColor,
          textStyle: theme.textTheme.bodyMedium?.copyWith(
            color: _isActive ? theme.primaryColorDark : theme.primaryColor,
            fontWeight: !Platform.isIOS && !Platform.isAndroid && _isActive
                ? FontWeight.w700
                : FontWeight.w500,
          ),
          onHighlightChanged: (isPressing) {
            setState(() {
              _isActive = isPressing;
            });
          },
          clipBehavior: Clip.none,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 34,
              vertical: 16,
            ),
            child: Text(
              widget.packageName,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
