import 'package:eventify/config/app_colors.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventScreen extends StatelessWidget {
  const UserEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = context.watch<EventProvider>();
    eventProvider.fetchUpcomingEvents(context.read<UserProvider>().currentUser!.rememberToken ?? '');
    eventProvider.sortEventsByTime();

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ListView.builder(
        itemCount: eventProvider.eventList.length,
        itemBuilder: (context, index) {
          final event = eventProvider.eventList[index];
          return EventCard(event: event);
        },
      ),
    );
  }

  List<Widget> getCategories(List<String> categories) {
    List<Widget> categoryList = [];

    for (String category in categories) {
      categoryList.add(ExpandableFabButton(category, Icon(Icons.filter_alt_outlined), AppColors.darkOrange));
    }

    return categoryList;
  }

  Row ExpandableFabButton(String category_name, Icon icon, Color color) {
    return Row(
        children: [
          Text(category_name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          const SizedBox(width: 20),
          FloatingActionButton.small(
            backgroundColor: color,
            heroTag: null,
            onPressed: null,
            child: icon,
          ),
        ],
      );
  }
}
