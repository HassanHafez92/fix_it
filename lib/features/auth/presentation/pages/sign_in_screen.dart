import 'package:fix_it/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import 'package:fix_it/core/utils/app_routes.dart';

/// SignInScreen
///
/// Business Rules:
/// - Collects user credentials and triggers the authentication flow via
///   [AuthBloc].
/// - Prevents submission when form validation fails.
/// - On successful authentication the user is routed to the home screen.
///
/// Dependencies:
/// - Depends on [AuthBloc] to emit authenticated/error states used by the UI.
///
/// Error scenarios:
/// - Validation errors surface inline; backend/auth failures present a
///   snackbar with a human-friendly message.

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  /// dispose
  ///
  /// Description: Briefly explain what this method does.
  ///
  /// Parameters:
  /// - (describe parameters)
  ///
  /// Returns:
  /// - (describe return value)

  @override

  /// dispose
  ///
  /// Description: Briefly explain what this method does.
  ///
  /// Parameters:
  /// - (describe parameters)
  ///
  /// Returns:
  /// - (describe return value)
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// build
  ///
  /// Description: Briefly explain what this method does.
  ///
  /// Parameters:
  /// - (describe parameters)
  ///
  /// Returns:
  /// - (describe return value)

  @override

  /// build
  ///
  /// Description: Briefly explain what this method does.
  ///
  /// Parameters:
  /// - (describe parameters)
  ///
  /// Returns:
  /// - (describe return value)
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 24.0,
              bottom: 24.0 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    l10n.welcomeBack,
                    style: GoogleFonts.cairo(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.signInToContinue(AppConstants.appName),
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    label: l10n.emailLabel,
                    hintText: l10n.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.validateEmail,
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: l10n.passwordLabel,
                    hintText: l10n.passwordHint,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: Validators.validatePassword,
                  ),

                  const SizedBox(height: 16),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.forgotPassword);
                      },
                      child: Text(
                        l10n.forgotPassword,
                        style: GoogleFonts.cairo(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sign In Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: l10n.signIn,
                        isLoading: state is AuthLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            safeAddEvent<AuthBloc>(
                              context,
                              SignInEvent(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          l10n.or,
                          style: GoogleFonts.cairo(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Social / Phone Sign In Buttons
                  CustomButton(
                    text: l10n.continueWithGoogle,
                    onPressed: () {
                      safeAddEvent<AuthBloc>(context, SignInWithGoogleEvent());
                    },
                    backgroundColor: Colors.white,
                    textColor: Colors.grey[800],
                    borderColor: Colors.grey[300],
                    icon: Icons.g_mobiledata,
                  ),

                  const SizedBox(height: 12),
                  CustomButton(
                    text: l10n.signInWithPhone,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.phoneSignIn);
                    },
                    backgroundColor: Colors.white,
                    textColor: Colors.grey[800],
                    borderColor: Colors.grey[300],
                    icon: Icons.phone_iphone,
                  ),

                  const SizedBox(height: 24),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontHaveAnAccount,
                        style: GoogleFonts.cairo(
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/sign-up');
                        },
                        child: Text(
                          l10n.signUp,
                          style: GoogleFonts.cairo(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
