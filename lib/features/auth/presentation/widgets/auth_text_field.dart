import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String labelText;
  final IconData prefixIcon;
  final bool isLoading;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? helperText;
  final VoidCallback? onInteraction;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.focusNode,
    this.nextFocusNode,
    this.isLoading = false,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.helperText,
    this.onInteraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFocus = focusNode?.hasFocus ?? false;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      enabled: !isLoading,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: Icon(
          prefixIcon,
          color: hasFocus ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
      onChanged: (_) {
        onInteraction?.call();
      },
      onFieldSubmitted: (_) {
        nextFocusNode?.requestFocus();
      },
    );
  }
}

