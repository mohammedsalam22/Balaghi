import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/constants.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_loading_button.dart';
import '../widgets/auth_error_snackbar.dart';
import 'verify_otp_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterView();
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFormValid = false;
  bool _hasUserInteracted = false;
  String? _registeredEmail;

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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

  void _handleRegister() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _registeredEmail = _emailController.text.trim();
      context.read<AuthCubit>().register(
        fullName: _fullNameController.text.trim(),
        email: _registeredEmail!,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
    } else {
      // Show error message if form is invalid
      _validateForm();
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
            title: Text(l10n.signUp),
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
                if (state is AuthRegistered) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerifyOtpPage(email: _registeredEmail!),
                    ),
                  );
                } else if (state is AuthError) {
                  // Dismiss keyboard on error
                  FocusScope.of(context).unfocus();
                  AuthErrorSnackbar.show(context, state);
                }
              },
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxHeight < 700;
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
                                      padding: EdgeInsets.all(
                                        isSmallScreen ? 32 : 40,
                                      ),
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
                                        autovalidateMode: _hasUserInteracted
                                            ? AutovalidateMode.onUserInteraction
                                            : AutovalidateMode.disabled,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            // Header
                                            Text(
                                              l10n.createAccount,
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
                                            SizedBox(
                                              height: isSmallScreen ? 8 : 12,
                                            ),
                                            Text(
                                              l10n.signUpToGetStarted,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: colorScheme.onSurface
                                                        .withOpacity(0.6),
                                                    fontSize: 14,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 24 : 32,
                                            ),
                                            // Full Name Field
                                            AuthTextField(
                                              controller: _fullNameController,
                                              focusNode: _fullNameFocusNode,
                                              nextFocusNode: _emailFocusNode,
                                              labelText: l10n.fullName,
                                              prefixIcon: Icons.person_outlined,
                                              isLoading: isLoading,
                                              validator: (value) =>
                                                  Validators.required(
                                                    value,
                                                    fieldName: l10n.fullName,
                                                  ),
                                              onInteraction: () {
                                                if (!_hasUserInteracted) {
                                                  setState(() {
                                                    _hasUserInteracted = true;
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 16 : 20,
                                            ),
                                            // Email Field
                                            AuthEmailField(
                                              controller: _emailController,
                                              focusNode: _emailFocusNode,
                                              nextFocusNode: _passwordFocusNode,
                                              isLoading: isLoading,
                                              validator: Validators.email,
                                              onInteraction: () {
                                                if (!_hasUserInteracted) {
                                                  setState(() {
                                                    _hasUserInteracted = true;
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 16 : 20,
                                            ),
                                            // Password Field
                                            AuthPasswordField(
                                              controller: _passwordController,
                                              focusNode: _passwordFocusNode,
                                              nextFocusNode:
                                                  _confirmPasswordFocusNode,
                                              obscurePassword: _obscurePassword,
                                              isLoading: isLoading,
                                              onToggleVisibility: () {
                                                setState(() {
                                                  _obscurePassword =
                                                      !_obscurePassword;
                                                });
                                              },
                                              helperText: l10n
                                                  .minimumCharacters(
                                                    AppConstants
                                                        .minPasswordLength,
                                                  ),
                                              validator: Validators.password,
                                              onInteraction: () {
                                                if (!_hasUserInteracted) {
                                                  setState(() {
                                                    _hasUserInteracted = true;
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 16 : 20,
                                            ),
                                            // Confirm Password Field
                                            AuthPasswordField(
                                              controller:
                                                  _confirmPasswordController,
                                              focusNode:
                                                  _confirmPasswordFocusNode,
                                              obscurePassword:
                                                  _obscureConfirmPassword,
                                              isLoading: isLoading,
                                              onToggleVisibility: () {
                                                setState(() {
                                                  _obscureConfirmPassword =
                                                      !_obscureConfirmPassword;
                                                });
                                              },
                                              labelText: l10n.confirmPassword,
                                              validator: (value) =>
                                                  Validators.match(
                                                    value,
                                                    _passwordController.text,
                                                    fieldName: l10n.password,
                                                  ),
                                              onInteraction: () {
                                                if (!_hasUserInteracted) {
                                                  setState(() {
                                                    _hasUserInteracted = true;
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 24 : 32,
                                            ),
                                            // Sign Up Button
                                            AuthLoadingButton(
                                              text: l10n.signUp,
                                              isEnabled: _isFormValid,
                                              onPressed: _handleRegister,
                                              isSmallScreen: isSmallScreen,
                                            ),
                                            SizedBox(
                                              height: isSmallScreen ? 16 : 24,
                                            ),
                                            // Sign In Link
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${l10n.alreadyHaveAccount} ',
                                                  style: theme
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                TextButton(
                                                  onPressed: isLoading
                                                      ? null
                                                      : () => Navigator.pop(
                                                          context,
                                                        ),
                                                  child: Text(l10n.signIn),
                                                ),
                                              ],
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
