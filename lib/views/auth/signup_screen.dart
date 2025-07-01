import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';
import '../../constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../views/widgets/category_chip.dart';
import '../../views/widgets/custom_input_field.dart';
import '../../views/widgets/custom_snackbar.dart';
import '../../views/widgets/gradient_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<String> selectedInterests = [];
  bool _isPasswordVisible = false;
  bool _acceptedTerms = false;

  Future<void> _submitSignup() async {
    if (_formKey.currentState!.validate()) {
      if (selectedInterests.isEmpty) {
        showCustomSnackbar(context, 'Please select at least one interest', isError: true);
        return;
      }

      if (!_acceptedTerms) {
        showCustomSnackbar(context, 'Please accept the terms and conditions', isError: true);
        return;
      }

      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      authVM.clearError();

      final success = await authVM.signUp(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _mobileController.text.trim(),
        selectedInterests,
        _passwordController.text.trim(),
      );

      if (mounted) {
        if (success) {
          showCustomSnackbar(
            context, 
            'Account created successfully!', 
            isError: false
          );
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => const LoginScreen())
          );
        } else {
          showCustomSnackbar(
            context, 
            authVM.errorMessage ?? 'Signup failed', 
            isError: true
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "Join EventBuddy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primaryBlue, AppColors.secondaryPurple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.calendar_today, size: 32, color: Colors.white),
                              SizedBox(height: 12),
                              Text(
                                "Create Your Account",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Start organizing and tracking amazing events!",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Username Field
                        CustomInputField(
                          controller: _usernameController,
                          label: 'Username',
                          icon: Icons.person_outline,
                          validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
                        ),

                        const SizedBox(height: 16),

                        // Email Field
                        CustomInputField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) return 'Email is required';
                            if (!value.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Mobile Field
                        CustomInputField(
                          controller: _mobileController,
                          label: 'Mobile Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) return 'Mobile number is required';
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return 'Enter a valid 10-digit number';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Interests Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Event Interests",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: CategoryData.categories.keys.map((category) {
                                if (category == 'All') return const SizedBox.shrink();
                                return CategoryChip(
                                  category: category,
                                  isSelected: selectedInterests.contains(category),
                                  onTap: () {
                                    setState(() {
                                      if (selectedInterests.contains(category)) {
                                        selectedInterests.remove(category);
                                      } else {
                                        selectedInterests.add(category);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Password Field
                        CustomInputField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isPasswordVisible: _isPasswordVisible,
                          onTogglePasswordVisibility: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Password is required';
                            if (value.length < 6) return 'At least 6 characters';
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Terms Checkbox
                        CheckboxListTile(
                          value: _acceptedTerms,
                          onChanged: (value) => setState(() => _acceptedTerms = value!),
                          title: const Text(
                            'I agree to the Terms and Conditions',
                            style: TextStyle(fontSize: 14),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),

                        const SizedBox(height: 24),

                        // Signup Button
                        Consumer<AuthViewModel>(
                          builder: (context, authVM, child) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: authVM.isLoading ? null : _submitSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: authVM.isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Create Account'),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Login Link
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            ),
                            child: const Text(
                              "Already have an account? Sign In",
                              style: TextStyle(color: AppColors.primaryBlue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}