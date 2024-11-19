import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<UserProvider>().currentUser?.id;
      if (userId != null) {
        context.read<EventProvider>().fetchEventsByUser(userId);
      }
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = context.watch<EventProvider>();
    
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: RefreshIndicator(
        onRefresh: () { return eventProvider.fetchEvents(); },
        child: ListView.builder(
          itemCount: eventProvider.filteredEventList.length,
          itemBuilder: (context, index) {
            final event = eventProvider.filteredEventList[index];
            return EventCard(event: event, eventProvider: eventProvider,);
          },
        ),
      ),
    );
  }
}
