// ignore_for_file: use_build_context_synchronously

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/admin_screen.dart';
import 'package:eventify/screens/forms/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    
    _animation = Tween<double>(begin: 800, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 79, 0),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                transform: Matrix4.translationValues(0, _animation.value, 0),
                padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/eventify-logo.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 60),

                    // Login form
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: LoginForm(),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text('Don\'t have an account yet?', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 10),
                          SignUpButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
