// ignore_for_file: use_build_context_synchronously

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/admin_screen.dart';
import 'package:eventify/screens/login/admin_view_placeholder.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> loginFormKey;
  final UserProvider userProvider;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.userProvider,
    required this.emailController,
    required this.passwordController,
    required this.loginFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: AppColors.darkOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () async {
        if(loginFormKey.currentState!.validate()){
          await tryLogin(context);
        }
      },
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 23),
      ),
    );
  }

  Future<void> tryLogin(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    
    await userProvider.loginUser(email, password);
    
    if (userProvider.loginErrorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userProvider.loginErrorMessage!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const AdminScreen()));
    }
  }
}
