// ignore_for_file: deprecated_member_use

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/screens/admin/manage_users_screen.dart';
import 'package:eventify/screens/temporal/coming_soon_screen.dart';
import 'package:eventify/widgets/dialogs/_show_logout_confirmation_dialog.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int currentScreenIndex = 0;

  final List<Widget> screenList = [
    const ManageUsersScreen(),
    const ComingSoonScreen()
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showLogoutConfirmationDialog(context);
        return Future.value(false);
      },
      child: Scaffold(
          // AppBar
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Image.asset('assets/images/eventify-text.png', height: 50),
            ),
            actions: [
              IconButton(
                onPressed: (){
                  showLogoutConfirmationDialog(context);
                },
              icon: const Icon(Icons.logout))
            ],
            elevation: 12.0,
            shadowColor: Colors.black.withOpacity(0.5),
            scrolledUnderElevation: 20,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
          ),

          // Body properties
          extendBody: true,
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),

          // Body
          body: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/no-filter-events-background-image.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // PageView
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: screenList,
              ),
            ],
          ),

          // Bottom Navigation Bar
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
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: BottomNavigationBar(
                iconSize: 30,
                items: [
                  createNavigationBarItem('Manage Users', 0),
                  createNavigationBarItem('Coming Soon!', 1),
                ],
                currentIndex: currentScreenIndex,
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                elevation: 20.0,
              ),
            ),
          ),
    ));
  }

  BottomNavigationBarItem createNavigationBarItem(String title, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: currentScreenIndex == index
              ? AppColors.deepOrange
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          getIcon(index),
          color: currentScreenIndex == index ? Colors.white : Colors.black,
        ),
      ),
      label: title,
    );
  }

  // Method to set the icon of the elements in the bottom navigation bar
  IconData getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.event;
      case 1:
        return Icons.event_available;
      default:
        return Icons.text_format;
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }
}
