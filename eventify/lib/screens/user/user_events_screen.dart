import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventsScreen extends StatefulWidget {
  const UserEventsScreen({super.key});

  @override
  _UserEventsScreenState createState() => _UserEventsScreenState();
}

class _UserEventsScreenState extends State<UserEventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<UserProvider>().currentUser?.id;
      if (userId != null) {
        context.read<EventProvider>().fetchEventsByUser(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = context.watch<EventProvider>();
    final userId = context.read<UserProvider>().currentUser?.id;

    if (userId == null) {
      return const Center(child: Text('User not logged in'));
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: RefreshIndicator(
        onRefresh: () { return eventProvider.fetchEventsByUser(userId); },
        child: ListView.builder(
          itemCount: eventProvider.userEventList
              .where((event) => event.startTime.isAfter(DateTime.now()))
              .length,
          itemBuilder: (context, index) {
            final event = eventProvider.userEventList
                .where((event) => event.startTime.isAfter(DateTime.now()))
                .toList()[index];
            return EventCard(event: event, eventProvider: eventProvider,);
          },
        ),
      ),
    );
  }
}