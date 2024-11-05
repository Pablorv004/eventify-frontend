import 'package:eventify/screens/temporal/coming_soon_screen.dart';
import 'package:eventify/screens/user/user_event_screen.dart';
import 'package:eventify/widgets/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final screenList = [UserEventScreen(), ComingSoonScreen()];
  int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Events"),
      ),
      body: screenList[currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Coming Soon!',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          setState(() {
            currentScreenIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const FilterButton(),
    );
  }
}
