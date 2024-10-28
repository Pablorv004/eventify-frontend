// ignore_for_file: use_build_context_synchronously

import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/admin_screen.dart';
import 'package:eventify/screens/login/admin_view_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:eventify/config/app_colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    UserProvider userProvider = context.watch<UserProvider>();

    InputDecoration inputDecoration = InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: AppColors.darkOrange,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: AppColors.softOrange,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 120),
              Image.asset(
                'assets/images/eventify-logo.png',
                width: 220,
                height: 220,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                width: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: AppColors.burntOrange,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      decoration: inputDecoration,
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: AppColors.burntOrange,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      decoration: inputDecoration,
                      controller: passwordController,
                    ),
                  ],
                ),
              ),
              LoginButton(
                userProvider: userProvider,
                emailController: emailController,
                passwordController: passwordController,
              ),
              const SizedBox(
                height: 90,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account yet?'),
                  SizedBox(
                    width: 10,
                  ),
                  SignUpButton(),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: AppColors.darkOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () {},
      child: const Text(
        'Sign up',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final UserProvider userProvider;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.userProvider,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: AppColors.darkOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () async {
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AdminScreen()));
        }
      },
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
