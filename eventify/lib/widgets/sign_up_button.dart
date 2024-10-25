// ignore_for_file: use_build_context_synchronously

import 'package:eventify/config/app_colors.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: AppColors.darkOrange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () {
        // TODO: IMPLEMENT NAVIGATION TO REGISTER SCREEN
      },
      child: const Text(
        'Sign up',
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}


