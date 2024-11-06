// ignore_for_file: deprecated_member_use

import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/manage_users_screen.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/widgets/admin_screen_card.dart';
import 'package:eventify/widgets/dialogs/_show_logout_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Container containerTop = Container(
      alignment: Alignment.centerLeft,
      child: const Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Hello, Admin!',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'What will you do today?',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(
            height: 20,
            thickness: 2,
            color: Colors.grey,
          ),
          AdminScreenCard(
              title: "Manage Users",
              description: "Manage activation, verification & user data.",
              imageAsset: 'assets/images/manage-users.jpg',
              destinationScreen: ManageUsersScreen()),
          AdminScreenCard(
              title: "Manage Events",
              description: "Manage event data, attendance, and information.",
              imageAsset: 'assets/images/manage-events.png',
              destinationScreen: PlaceholderScreen()),
        ],
      ),
    );


    return WillPopScope(
      onWillPop: () async {
        showLogoutConfirmationDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/eventify-text.png', height: 40),
          actions: [
            IconButton(
                onPressed: () {
                  showLogoutConfirmationDialog(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: containerTop,
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placeholder Screen'),
      ),
      body: const Center(
        child: Text('This is a placeholder screen.'),
      ),
    );
  }
}
