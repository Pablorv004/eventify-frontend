import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => UserProvider(UserService(), AuthService())),
        ChangeNotifierProvider( create: (_) => EventProvider(EventService(), AuthService())),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.deepOrange,
            secondary: AppColors.lightOrange,
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: AppColors.deepOrange,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        title: 'Eventify',
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: LoginScreen()
        ),
      ),
    );
  }
}