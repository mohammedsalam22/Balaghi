import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../widgets/login_logo_widget.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/login_remember_forgot_row.dart';
import '../widgets/auth_loading_button.dart';
import '../widgets/login_signup_link.dart';
import '../widgets/auth_error_snackbar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isFormValid = false;
  bool _hasUserInteracted = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    // Don't auto-focus - let user tap to focus
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  String? _emailValidator(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return l10n?.emailRequired ?? 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return l10n?.emailInvalid ?? 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.passwordRequired ?? 'Password is required';
    }
    return null;
  }

  void _handleLogin() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      // Show error message if form is invalid
      _validateForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              // Dismiss keyboard on error
              FocusScope.of(context).unfocus();
              AuthErrorSnackbar.show(context, state);
            }
            // Navigation is handled in main.dart based on AuthState
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
                                // Logo outside card
                                const LoginLogoWidget(),
                                SizedBox(height: isSmallScreen ? 24 : 32),
                                // Card with form
                                Container(
                                  width: maxWidth,
                                  constraints: const BoxConstraints(
                                    maxWidth: 450,
                                  ),
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    autovalidateMode: _hasUserInteracted
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const LoginTitleWidget(),
                                        const SizedBox(height: 32),
                                        // Email Field
                                        AuthEmailField(
                                          controller: _emailController,
                                          focusNode: _emailFocusNode,
                                          nextFocusNode: _passwordFocusNode,
                                          isLoading: isLoading,
                                          validator: _emailValidator,
                                          onInteraction: () {
                                            if (!_hasUserInteracted) {
                                              setState(() {
                                                _hasUserInteracted = true;
                                              });
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        // Password Field
                                        AuthPasswordField(
                                          controller: _passwordController,
                                          focusNode: _passwordFocusNode,
                                          obscurePassword: _obscurePassword,
                                          isLoading: isLoading,
                                          validator: _passwordValidator,
                                          onToggleVisibility: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                          onInteraction: () {
                                            if (!_hasUserInteracted) {
                                              setState(() {
                                                _hasUserInteracted = true;
                                              });
                                            }
                                          },
                                          onSubmit: () {
                                            if (_isFormValid && !isLoading) {
                                              _handleLogin();
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        // Remember Me & Forgot Password Row
                                        LoginRememberForgotRow(
                                          rememberMe: _rememberMe,
                                          isLoading: isLoading,
                                          onRememberMeChanged: (value) {
                                            setState(() {
                                              _rememberMe = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 24),
                                        // Login Button
                                        AuthLoadingButton(
                                          text: AppLocalizations.of(
                                            context,
                                          )!.signIn,
                                          isEnabled: _isFormValid,
                                          onPressed: _handleLogin,
                                          isSmallScreen: isSmallScreen,
                                        ),
                                        const SizedBox(height: 16),
                                        // Sign Up Link
                                        LoginSignupLink(isLoading: isLoading),
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
  }
}
