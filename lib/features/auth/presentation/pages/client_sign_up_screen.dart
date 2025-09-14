import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/utils/app_routes.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import '../bloc/client_sign_up/client_sign_up_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:fix_it/l10n/app_localizations.dart';
/// ClientSignUpScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.
/// ClientSignUpScreen
///
/// Business rules:
/// - Describe the business rules that this class enforces.
///
/// Dependencies:
/// - List important dependencies or preconditions.
///
/// Error scenarios:
/// - Describe common error conditions and how they are handled.



class ClientSignUpScreen extends StatefulWidget {
  const ClientSignUpScreen({super.key});

  @override
  State<ClientSignUpScreen> createState() => _ClientSignUpScreenState();
}

class _ClientSignUpScreenState extends State<ClientSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        title: Text(
          l10n.createClientAccount,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ClientSignUpBloc, ClientSignUpState>(
        listener: (context, state) {
          if (state is ClientSignUpSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is ClientSignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // Welcome text
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.person_add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.welcomeClient,
                          style: GoogleFonts.cairo(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.fillYourInfo,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: const Color(0xFF718096),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Form fields
                    CustomTextField(
                      controller: _nameController,
                      label: l10n.fullName,
                      hintText: l10n.enterYourFullName,
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      validator: Validators.validateName,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _emailController,
                      label: l10n.emailLabel,
                      hintText: l10n.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.validateEmail,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _phoneController,
                      label: l10n.phoneNumber,
                      hintText: l10n.enterYourPhoneNumber,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      validator: Validators.validatePhone,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _passwordController,
                      label: l10n.passwordLabel,
                      hintText: l10n.passwordHint,
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF718096),
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

                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: l10n.confirmPassword,
                      hintText: l10n.reEnterYourPassword,
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF718096),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return l10n.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Terms and conditions
                    Row(
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                          activeColor: theme.primaryColor,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _acceptTerms = !_acceptTerms;
                              });
                            },
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: l10n.iAgreeTo,
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: const Color(0xFF718096),
                                    ),
                                  ),
                                  TextSpan(
                                    text: l10n.termsAndConditions,
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: l10n.and,
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: const Color(0xFF718096),
                                    ),
                                  ),
                                  TextSpan(
                                    text: l10n.privacyPolicy,
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sign up button
                    CustomButton(
                      text: l10n.createAccount,
                      isLoading: state is ClientSignUpLoading,
                      onPressed: _acceptTerms ? _signUp : null,
                    ),

                    const SizedBox(height: 24),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAnAccount,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: const Color(0xFF718096),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.signIn,
                          ),
                          child: Text(
                            l10n.signIn,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      safeAddEvent<ClientSignUpBloc>(
        context,
        ClientSignUpSubmitted(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim(),
        ),
      );
    }
  }
}
