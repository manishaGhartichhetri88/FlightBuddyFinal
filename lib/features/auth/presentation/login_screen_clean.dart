// Clean Architecture Login Screen with Riverpod

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flightbuddy/core/providers/providers.dart';

class LoginScreenClean extends ConsumerStatefulWidget {
  const LoginScreenClean({super.key});

  @override
  ConsumerState<LoginScreenClean> createState() => _LoginScreenCleanState();
}

class _LoginScreenCleanState extends ConsumerState<LoginScreenClean> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController fullNameController;
  bool isRegistering = false;
  final Color primary = const Color(0xFF1565C0);

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorDialog('Please fill all fields');
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.login(
        emailController.text,
        passwordController.text,
      );

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        _showErrorDialog('Invalid credentials');
      }
    } catch (e) {
      _showErrorDialog('Error during login: ${e.toString()}');
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _handleRegister() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        fullNameController.text.isEmpty) {
      _showErrorDialog('Please fill all fields');
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.register(
        emailController.text,
        passwordController.text,
        fullNameController.text,
      );

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          setState(() => isRegistering = false);
          emailController.clear();
          passwordController.clear();
          fullNameController.clear();
        }
      } else {
        _showErrorDialog('Registration failed');
      }
    } catch (e) {
      _showErrorDialog('Error during registration: ${e.toString()}');
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginLoadingProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // App Logo/Title
              Text(
                'Flight Buddy',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                isRegistering ? 'Create Account' : 'Welcome Back',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 40),

              // Full Name Field (Only in Register mode)
              if (isRegistering)
                Column(
                  children: [
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),

              // Login/Register Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : isRegistering
                          ? _handleRegister
                          : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isRegistering ? 'Create Account' : 'Login',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 15),

              // Toggle Register/Login
              GestureDetector(
                onTap: () {
                  setState(() => isRegistering = !isRegistering);
                  emailController.clear();
                  passwordController.clear();
                  fullNameController.clear();
                },
                child: Text.rich(
                  TextSpan(
                    text: isRegistering
                        ? 'Already have an account? '
                        : 'Don\'t have an account? ',
                    children: [
                      TextSpan(
                        text: isRegistering ? 'Login' : 'Register',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Social Login Options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton(Icons.g_translate, 'Google'),
                  const SizedBox(width: 20),
                  _buildSocialButton(Icons.apple, 'Apple'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label login not yet implemented')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
