// ignore_for_file: use_build_context_synchronously

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/event.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/screens/organizer/organizer_event_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class EventListCard extends StatelessWidget {
  const EventListCard({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(event.id),
      closeOnScroll: true,
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrganizerEventForm(event: event),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 29, 101, 255),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          autoClose: true,
          icon: Icons.edit,
        ),
        SlidableAction(
          onPressed: (context) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Deletion'),
                content: const Text('Are you sure you want to delete this event?'),
                actions: <Widget>[
                TextButton(
                  onPressed: () {
                  Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                  context.read<EventProvider>().deleteEvent(event);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                    content: Text('${event.title} has been deleted'),
                    ),
                  );
                  },
                  child: const Text('Delete'),
                ),
                ],
              );
              },
            );
          },
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          autoClose: true,
          icon: Icons.delete,
        ),
      ]),
      child: Card(
        margin: const EdgeInsets.all(5),
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.vibrantOrange, width: 2),
          borderRadius: BorderRadius.circular(7),
        ),
        color: Colors.white,
        child: ListTile(
          leading: SizedBox(
            height: 50,
            width: 50,
            child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                ? Image.network(
                    event.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/app_logo.png',
                          fit: BoxFit.cover);
                    },
                  )
                : Image.asset('assets/images/app_logo.png', fit: BoxFit.cover),
          ),
          title: Text(
            event.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${event.startTime.toLocal().day}/${event.startTime.toLocal().month}/${event.startTime.toLocal().year}',
            style: const TextStyle(fontSize: 18),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.softOrange, width: 2),
            ),
            child: Text(
              event.category!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
