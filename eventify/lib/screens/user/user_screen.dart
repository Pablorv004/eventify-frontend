import 'package:eventify/config/app_colors.dart';
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
        title: Image.asset('assets/images/eventify-text.png', height: 50),
        scrolledUnderElevation: 20,
        centerTitle: true,
      ),
      body: screenList[currentScreenIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 5, right: 5, left: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(30)
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(30)
          ),
          child: BottomNavigationBar(
            iconSize: 30,
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
            currentIndex: currentScreenIndex,
            onTap: (index) {
              setState(() {
                currentScreenIndex = index;
              });
            },
            elevation: 20.0,
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const FilterButton(),
    );
  }
}
