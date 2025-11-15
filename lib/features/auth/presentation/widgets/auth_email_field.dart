import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class AuthEmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool isLoading;
  final String? Function(String?)? validator;
  final VoidCallback? onInteraction;

  const AuthEmailField({
    super.key,
    required this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.isLoading = false,
    this.validator,
    this.onInteraction,
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
      keyboardType: TextInputType.emailAddress,
      textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      enabled: !isLoading,
      decoration: InputDecoration(
        labelText: l10n.email,
        hintText: 'example@email.com',
        prefixIcon: Icon(
          Icons.email_outlined,
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

