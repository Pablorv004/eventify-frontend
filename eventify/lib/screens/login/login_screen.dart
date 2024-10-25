import 'package:eventify/screens/forms/login_form.dart';
import 'package:eventify/widgets/sign_up_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 150),
                    Image.asset(
                      'assets/images/eventify-logo.png',
                      width: 240,
                      height: 240,
                    ),
                    const SizedBox(height: 80),

                    // Login form
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: LoginForm(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account yet?'),
                SizedBox(width: 10),
                SignUpButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
