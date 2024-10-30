import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/admin/manage_users_screen.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/widgets/admin_screen_card.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/eventify-text.png', height: 40),
        actions: [
          IconButton(
            onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: containerTop,
      ),
    );
  }
}

// Dialog asking the user to logout
void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you really want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserProvider>().userLogout();
              // We use pushAndRemoveUntil to clean the routes of the application
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
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
