import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/event_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class OrganizerEventsScreen extends StatefulWidget {
  const OrganizerEventsScreen({super.key});

  @override
  _OrganizerEventsScreenState createState() => _OrganizerEventsScreenState();
}

class _OrganizerEventsScreenState extends State<OrganizerEventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<UserProvider>().currentUser?.id;
      if (userId != null) {
        context.read<EventProvider>().fetchEventsByOrganizer(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    EventProvider eventProvider = context.watch<EventProvider>();

    if (eventProvider.organizerEventList.isEmpty) {
      return const Center(
          child: Text(
        'You\'re not organizing any events yet!',
        style: TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis),
      ));
    }
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: ListView.builder(
        itemCount: eventProvider.organizerEventList.length,
        itemBuilder: (context, index) {
          final event = eventProvider.organizerEventList[index];
          return EventListCard(event: event);
        },
      ),
    );
  }
}
