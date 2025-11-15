import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../pages/forgot_password_page.dart';

class LoginRememberForgotRow extends StatelessWidget {
  final bool rememberMe;
  final bool isLoading;
  final ValueChanged<bool> onRememberMeChanged;

  const LoginRememberForgotRow({
    super.key,
    required this.rememberMe,
    required this.isLoading,
    required this.onRememberMeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: isLoading
              ? null
              : (value) {
                  onRememberMeChanged(value ?? false);
                },
          activeColor: colorScheme.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: isLoading
                ? null
                : () {
                    onRememberMeChanged(!rememberMe);
                  },
            child: Text(
              l10n.rememberMe,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordPage(),
                    ),
                  );
                },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
          ),
          child: Text(l10n.forgotPassword),
        ),
      ],
    );
  }
}

