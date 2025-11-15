import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';

class AuthLoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSmallScreen;
  final bool isEnabled;

  const AuthLoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSmallScreen = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return ElevatedButton(
          onPressed: (isEnabled && !isLoading) ? onPressed : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              minimumSize: Size(double.infinity, isSmallScreen ? 48 : 50),
              elevation: 0,
              backgroundColor: colorScheme.primary,
            ),
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text(
                  text,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
        );
      },
    );
  }
}

