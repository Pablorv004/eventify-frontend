import 'package:flutter/material.dart';
import 'package:eventify/config/app_colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  

  @override
  Widget build(BuildContext context) {

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
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 180,
                ),

                Image.asset(
                  'assets/images/eventify-logo.png',
                  width: 220,
                  height: 220,
                ),

                const SizedBox(
                  height: 30,
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  width: 350,
                  child: Column(
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'User',
                            style: TextStyle(
                              color: AppColors.burntOrange,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),

                      TextField(
                        decoration: inputDecoration
                      ),

                      const SizedBox(
                        height: 25,
                      ),

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
                        decoration: inputDecoration
                      ),

                      FilledButton(
                        onPressed: (){},
                        child: Text('Login')
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
