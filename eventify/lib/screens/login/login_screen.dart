import 'package:eventify/screens/forms/login_form.dart';
import 'package:eventify/widgets/sign_up_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 79, 0),
      // backgroundColor: const Color.fromARGB(255, 182, 182, 182),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView( // Agregado para permitir el desplazamiento
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account yet?', style: TextStyle(fontSize: 16),),
                      SizedBox(width: 10),
                      SignUpButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
