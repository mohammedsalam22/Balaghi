import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class LoginLogoWidget extends StatelessWidget {
  const LoginLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final logoSize = isLargeScreen ? 240.0 : 200.0;
        final iconSize = isLargeScreen ? 200.0 : 160.0;
        
        return Center(
          child: Image.asset(
            'assets/imgaes/mainlogo.png',
            height: logoSize,
            width: logoSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.account_balance,
                size: iconSize,
                color: colorScheme.primary,
              );
            },
          ),
        );
      },
    );
  }
}

class LoginTitleWidget extends StatelessWidget {
  const LoginTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Sign In Title - cleaner typography
        Text(
          l10n.signIn,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 24,
            letterSpacing: 0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Subtitle - subtle
        Text(
          l10n.signInToContinue,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

