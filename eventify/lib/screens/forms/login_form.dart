import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // This global key does not refer to this class, but to the state of the form that it contains
  // It will be used for validating this form
  final _loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {

    final userProvider = context.watch<UserProvider>();

    return Form(
      key: _loginFormKey,
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

          TextFormField(
            decoration: getInputDecoration().copyWith(
              hintText: 'Enter your email',
              hintStyle: const TextStyle(color: Colors.grey)
            ),
            keyboardType: TextInputType.text,
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }

              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

              if (!emailRegex.hasMatch(value)) {
                return 'Insert a valid email';
              }

              return null;
            },
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

          TextFormField(
            decoration: getInputDecoration().copyWith(
              hintText: 'Enter your password',
              hintStyle: const TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: _isPasswordVisible,
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }

              return null;
            },
          ),

          const SizedBox(height: 30,),

          LoginButton(userProvider: userProvider, emailController: emailController, passwordController: passwordController, loginFormKey: _loginFormKey,)
        ],
      ),
    );
  }

  InputDecoration getInputDecoration() {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: AppColors.darkOrange,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: AppColors.darkOrange,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2,
          color: AppColors.softOrange,
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
  }
}
