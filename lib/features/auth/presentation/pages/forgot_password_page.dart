import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_loading_button.dart';
import '../widgets/auth_error_snackbar.dart';
import '../widgets/auth_success_snackbar.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ForgotPasswordView();
  }
}

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgotPassword(
        email: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final logoSize = isLargeScreen ? 110.0 : 90.0;
        final iconSize = isLargeScreen ? 80.0 : 64.0;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.forgotPassword),
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Image.asset(
                    'assets/imgaes/mainlogo_appbar.png',
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
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthPasswordResetSent) {
                  AuthSuccessSnackbar.show(context, state.message);
                  Navigator.pop(context);
                } else if (state is AuthError) {
                  FocusScope.of(context).unfocus();
                  AuthErrorSnackbar.show(context, state);
                }
              },
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxHeight < 600;
                      final maxWidth = constraints.maxWidth > 600
                          ? 450.0
                          : constraints.maxWidth - 48;
                      final isWideScreen = constraints.maxWidth > 600;

                      return Stack(
                        children: [
                          Center(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWideScreen ? 0 : 24,
                                vertical: isSmallScreen ? 16 : 24,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Card with form
                                    Container(
                                      width: maxWidth,
                                      constraints: const BoxConstraints(
                                        maxWidth: 450,
                                      ),
                                      padding: const EdgeInsets.all(40),
                                      decoration: BoxDecoration(
                                        color: colorScheme.surface,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // Title
                                            Text(
                                              l10n.forgotPassword,
                                              style: theme
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 24,
                                                    letterSpacing: 0,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            // Subtitle
                                            Text(
                                              l10n.enterEmailToReset,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: colorScheme.onSurface
                                                        .withOpacity(0.6),
                                                    fontSize: 14,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 32),
                                            // Email Field
                                            AuthEmailField(
                                              controller: _emailController,
                                              isLoading: isLoading,
                                              validator: Validators.email,
                                            ),
                                            const SizedBox(height: 24),
                                            // Send Reset Link Button
                                            AuthLoadingButton(
                                              text: l10n.sendResetLink,
                                              onPressed: _handleForgotPassword,
                                              isSmallScreen: isSmallScreen,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Loading Overlay
                          if (isLoading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.1),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
