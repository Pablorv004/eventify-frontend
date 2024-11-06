import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => UserProvider(UserService())),
        ChangeNotifierProvider( create: (_) => EventProvider(EventService())),
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