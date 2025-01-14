// ignore_for_file: use_build_context_synchronously

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/admin_screen.dart';
import 'package:eventify/screens/organizer/organizer_screen.dart';
import 'package:eventify/screens/user/user_screen.dart';
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
      style: FilledButton.styleFrom(
          backgroundColor: AppColors.darkOrange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4),
      onPressed: () async {
        if (loginFormKey.currentState!.validate()) {
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
      await Future.delayed(const Duration(milliseconds: 100));
      userProvider.currentUser!.email = email;
      Widget targetScreen;
      if (userProvider.currentUser?.role == 'a') {
        targetScreen = const AdminScreen();
      } else if (userProvider.currentUser?.role == 'u') {
        targetScreen = const UserScreen();
      } else {
        targetScreen = const OrganizerScreen();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    }
  }
}
