import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/services/login_service.dart';
import 'package:eventify/services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => UserProvider(LoginService(), ValidationService())),
      ],
      child: const MaterialApp(
        title: 'Eventify',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: LoginScreen()
        ),
      ),
    );
  }
}