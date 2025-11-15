import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/auth/auth_state.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/utils/constants.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_loading_button.dart';
import '../widgets/auth_error_snackbar.dart';
import '../widgets/auth_success_snackbar.dart';
import 'login_page.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return ResetPasswordView(token: token);
  }
}

class ResetPasswordView extends StatefulWidget {
  final String token;

  const ResetPasswordView({super.key, required this.token});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(
        token: widget.token,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetPassword)),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetSuccess) {
              AuthSuccessSnackbar.show(context, state.message);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            } else if (state is AuthError) {
              AuthErrorSnackbar.show(context, state);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Icon(
                    Icons.lock_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.resetPassword,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.enterNewPassword,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AuthPasswordField(
                    controller: _newPasswordController,
                    focusNode: _newPasswordFocusNode,
                    nextFocusNode: _confirmPasswordFocusNode,
                    obscurePassword: _obscureNewPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    labelText: l10n.newPassword,
                    helperText: l10n.minimumCharacters(
                      AppConstants.minPasswordLength,
                    ),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  AuthPasswordField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    obscurePassword: _obscureConfirmPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    labelText: l10n.confirmPassword,
                    validator: (value) => Validators.match(
                      value,
                      _newPasswordController.text,
                      fieldName: l10n.password,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthLoadingButton(
                    text: l10n.resetPassword,
                    onPressed: _handleResetPassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
