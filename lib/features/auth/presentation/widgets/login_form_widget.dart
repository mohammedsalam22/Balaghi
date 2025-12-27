import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../widgets/auth_email_field.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/login_remember_forgot_row.dart';
import '../widgets/auth_loading_button.dart';
import '../widgets/login_signup_link.dart';
import '../utils/validation_utils.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
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
    final l10n = AppLocalizations.of(context);
    final emailValid = ValidationUtils.emailValidator(_emailController.text, l10n) == null;
    final passwordValid = ValidationUtils.passwordValidator(_passwordController.text, l10n) == null;
    final isValid = emailValid && passwordValid;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();

    final l10n = AppLocalizations.of(context);
    final emailError = ValidationUtils.emailValidator(_emailController.text, l10n);
    final passwordError = ValidationUtils.passwordValidator(_passwordController.text, l10n);

    if (emailError == null && passwordError == null) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      setState(() {
        _hasUserInteracted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthCubit>().state is AuthLoading;
    final isSmallScreen = MediaQuery.of(context).size.height < 600;

    return Form(
      key: _formKey,
      autovalidateMode: _hasUserInteracted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthEmailField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            nextFocusNode: _passwordFocusNode,
            isLoading: isLoading,
            validator: (value) => ValidationUtils.emailValidator(value, AppLocalizations.of(context)),
            onInteraction: () {
              if (!_hasUserInteracted) {
                setState(() {
                  _hasUserInteracted = true;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          AuthPasswordField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscurePassword: _obscurePassword,
            isLoading: isLoading,
            validator: (value) => ValidationUtils.passwordValidator(value, AppLocalizations.of(context)),
            onToggleVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
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
          AuthLoadingButton(
            text: AppLocalizations.of(context)!.signIn,
            isEnabled: _isFormValid,
            onPressed: _handleLogin,
            isSmallScreen: isSmallScreen,
          ),
          const SizedBox(height: 16),
          LoginSignupLink(isLoading: isLoading),
        ],
      ),
    );
  }
}
