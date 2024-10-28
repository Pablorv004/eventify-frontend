// ignore_for_file: use_build_context_synchronously

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> registerFormKey;
  final UserProvider userProvider;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterButton({
    super.key,
    required this.userProvider,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.registerFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.darkOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
      ),
      onPressed: () async {
        if (registerFormKey.currentState!.validate()) {
          await tryRegister(context);
        }
      },
      child: const Text(
        'Register',
        style: TextStyle(fontSize: 23),
      ),
    );
  }

  Future<void> tryRegister(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    await userProvider.registerUser(name, email, password, confirmPassword);

    if (userProvider.registerErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userProvider.registerErrorMessage!)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}