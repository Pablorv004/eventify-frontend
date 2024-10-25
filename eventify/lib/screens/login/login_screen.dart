import 'package:eventify/screens/forms/login_form.dart';
import 'package:eventify/widgets/sign_up_button.dart';
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
