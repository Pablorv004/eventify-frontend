import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    EventProvider eventProvider = context.watch<EventProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello, ${userProvider.currentUser!.name}!"),
            const Text("There's nothing here for you... YET!")
          ]
        ),
      ),
      floatingActionButton: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: AppColors.softOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
        onPressed: () {

        },
        icon: const Icon(Icons.filter_alt_outlined)
      ),
    );
  }
}
