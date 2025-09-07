import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/validators.dart';
import 'package:fix_it/core/utils/app_routes.dart';
import '../bloc/technician_sign_up/technician_sign_up_bloc.dart';
import 'package:fix_it/core/utils/bloc_utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class TechnicianSignUpScreen extends StatefulWidget {
  const TechnicianSignUpScreen({super.key});

  @override
  State<TechnicianSignUpScreen> createState() => _TechnicianSignUpScreenState();
}

class _TechnicianSignUpScreenState extends State<TechnicianSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  String? _selectedProfession;

  final List<String> _professions = [
    'كهربائي',
    'سباك',
    'نجار',
    'دهان',
    'مكيفات وتبريد',
    'فني أجهزة منزلية',
    'فني إلكترونيات',
    'عامل تنظيف',
    'بستاني',
    'نقاش',
    'مبلط',
    'حداد',
    'زجاج',
    'عازل أسطح',
    'ميكانيكي سيارات',
    'فني صيانة هواتف',
    'تركيب أثاث',
    'أخرى',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          'إنشاء حساب فني',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<TechnicianSignUpBloc, TechnicianSignUpState>(
        listener: (context, state) {
          if (state is TechnicianSignUpSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is TechnicianSignUpError) {
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
                            Icons.engineering,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'أهلاً بك كفني متخصص',
                          style: GoogleFonts.cairo(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'املأ البيانات التالية لإنشاء حسابك المهني',
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
                      label: 'الاسم الكامل',
                      hintText: 'أدخل اسمك الكامل',
                      keyboardType: TextInputType.name,
                      prefixIcon: Icons.person_outline,
                      validator: Validators.validateName,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      hintText: 'أدخل بريدك الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.validateEmail,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف',
                      hintText: 'أدخل رقم هاتفك',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      validator: Validators.validatePhone,
                    ),

                    const SizedBox(height: 16),

                    // Profession dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التخصص المهني',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedProfession,
                          decoration: InputDecoration(
                            hintText: 'اختر تخصصك المهني',
                            prefixIcon: const Icon(Icons.work_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: theme.primaryColor),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: _professions.map((profession) {
                            return DropdownMenuItem(
                              value: profession,
                              child: Text(
                                profession,
                                style: GoogleFonts.cairo(),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedProfession = value;
                              if (value == 'أخرى') {
                                _professionController.clear();
                              } else {
                                _professionController.text = value ?? '';
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى اختيار التخصص المهني';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    // Show custom profession field if "أخرى" is selected
                    if (_selectedProfession == 'أخرى') ...[
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _professionController,
                        label: 'حدد تخصصك',
                        hintText: 'أدخل تخصصك المهني',
                        prefixIcon: Icons.work_outline,
                        validator: (value) {
                          if (_selectedProfession == 'أخرى' &&
                              (value == null || value.isEmpty)) {
                            return 'يرجى تحديد التخصص المهني';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      hintText: 'أدخل كلمة المرور',
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
                      label: 'تأكيد كلمة المرور',
                      hintText: 'أعد إدخال كلمة المرور',
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
                          return 'كلمة المرور غير متطابقة';
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
                                    text: 'أوافق على ',
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: const Color(0xFF718096),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'الشروط والأحكام',
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' و ',
                                    style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      color: const Color(0xFF718096),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'سياسة الخصوصية',
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
                      text: 'إنشاء الحساب',
                      isLoading: state is TechnicianSignUpLoading,
                      onPressed: _acceptTerms ? _signUp : null,
                    ),

                    const SizedBox(height: 24),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟ ',
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
                            'تسجيل الدخول',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
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
      safeAddEvent<TechnicianSignUpBloc>(
        context,
        TechnicianSignUpSubmitted(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim(),
          profession: _selectedProfession == 'أخرى'
              ? _professionController.text.trim()
              : _selectedProfession ?? '',
        ),
      );
    }
  }
}
