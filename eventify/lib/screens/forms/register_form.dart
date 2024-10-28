import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/register_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _registerFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Form(
      key: _registerFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Name',
                style: TextStyle(
                  color: AppColors.burntOrange,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          TextFormField(
            decoration: getInputDecoration().copyWith(
              hintText: 'Enter your name',
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            keyboardType: TextInputType.text,
            controller: nameController,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
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
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            keyboardType: TextInputType.text,
            controller: emailController,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
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
                padding: EdgeInsets.only(right: 18),
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
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
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
                'Confirm Password',
                style: TextStyle(
                  color: AppColors.burntOrange,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          TextFormField(
            decoration: getInputDecoration().copyWith(
              hintText: 'Confirm your password',
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            obscureText: _isPasswordVisible,
            controller: confirmPasswordController,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }

              if (value != passwordController.text) {
                return 'Passwords do not match';
              }

              return null;
            },
          ),
          const SizedBox(height: 30),
          RegisterButton(
            userProvider: userProvider,
            nameController: nameController,
            emailController: emailController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            registerFormKey: _registerFormKey,
          ),
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