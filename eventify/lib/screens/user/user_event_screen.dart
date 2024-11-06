import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventScreen extends StatefulWidget {
  const UserEventScreen({super.key});

  @override
  _UserEventScreenState createState() => _UserEventScreenState();
}

class _UserEventScreenState extends State<UserEventScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = context.watch<EventProvider>();

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ListView.builder(
        itemCount: eventProvider.filteredEventList.length,
        itemBuilder: (context, index) {
          final event = eventProvider.filteredEventList[index];
          return EventCard(event: event);
        },
      ),
    );
  }
}
