import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool obscurePassword;
  final bool isLoading;
  final String? Function(String?)? validator;
  final VoidCallback onToggleVisibility;
  final VoidCallback? onInteraction;
  final VoidCallback? onSubmit;
  final String? labelText;
  final String? helperText;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.obscurePassword,
    required this.onToggleVisibility,
    this.focusNode,
    this.nextFocusNode,
    this.isLoading = false,
    this.validator,
    this.onInteraction,
    this.onSubmit,
    this.labelText,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasFocus = focusNode?.hasFocus ?? false;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscurePassword,
      textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      enabled: !isLoading,
      decoration: InputDecoration(
        labelText: labelText ?? l10n.password,
        helperText: helperText,
        prefixIcon: Icon(
          Icons.lock_outlined,
          color: hasFocus ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: hasFocus
                ? colorScheme.primary
                : colorScheme.onSurface.withOpacity(0.5),
          ),
          onPressed: isLoading ? null : onToggleVisibility,
          tooltip: obscurePassword ? 'Show password' : 'Hide password',
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
        if (onSubmit != null) {
          onSubmit!();
        } else {
          nextFocusNode?.requestFocus();
        }
      },
    );
  }
}

