import 'package:eventify/screens/forms/register_form.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 79, 0),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: Container(
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
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/eventify-logo.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                // Register form
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RegisterForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
