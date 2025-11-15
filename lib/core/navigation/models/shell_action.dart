import 'package:flutter/material.dart';

/// Represents an action button in the app bar
class ShellAction {
  final IconData icon;
  final void Function(BuildContext context) handler;
  final String? tooltip;

  const ShellAction({
    required this.icon,
    required this.handler,
    this.tooltip,
  });
}

