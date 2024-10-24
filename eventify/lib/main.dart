import 'package:eventify/domain/providers/user_provider.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => UserProvider()..getUsers() ),
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