import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/screens/login/login_screen.dart';
import 'package:eventify/screens/temporal/coming_soon_screen.dart';
import 'package:eventify/screens/user/user_event_screen.dart';
import 'package:eventify/widgets/expandable_fab_button.dart';
import 'package:eventify/widgets/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> screenList = [const UserEventScreen(), const ComingSoonScreen()];
  int currentScreenIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      onPopInvokedWithResult: (didPop, result){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        // AppBar
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Image.asset('assets/images/eventify-text.png', height: 50),
          ),
          elevation: 12.0,
          shadowColor: Colors.black.withOpacity(0.5), // Optional: Customize shadow color
          scrolledUnderElevation: 20,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
      
        // Body properties
        extendBodyBehindAppBar: true,
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
            borderRadius: const BorderRadius.all(
              Radius.circular(20)
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20)
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
                  _onBottomNavTapped(index);
                });
              },
              elevation: 20.0,
            ),
          ),
        ),
      
        // Floating action buttons
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: FilterButton(categoryList: buildExpandableButtons(context)),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  List<Widget> buildExpandableButtons(BuildContext context) {
    EventProvider eventProvider = context.read<EventProvider>();
    eventProvider.fetchCategories(context.read<UserProvider>().currentUser!.rememberToken!);
    List<String> categories = eventProvider.categories;
    List<Widget> categoryList = [];

    for(String category in categories){
      categoryList.add(ExpandableFabButton(category_name: category));
    }

    categoryList.add(ExpandableFabButton(category_name: 'Clear filter'));

    return categoryList;
  }
}
