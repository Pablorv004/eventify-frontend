import 'package:eventify/screens/admin/manage_users_screen.dart';
import 'package:flutter/material.dart';

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
          CardWidget(
              title: "Manage Users",
              description: "Manage activation, verification & user data.",
              imageAsset: 'assets/images/manage-users.jpg',
              destinationScreen: ManageUsersScreen()),
          CardWidget(
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 14.0),
        child: containerTop,
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String? imageAsset;
  final String title;
  final String description;
  final Widget destinationScreen;

  const CardWidget({
    super.key,
    this.imageAsset,
    required this.title,
    required this.description,
    required this.destinationScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                imageAsset ?? 'assets/images/placeholder.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
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
