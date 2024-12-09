// ignore_for_file: use_build_context_synchronously

import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/event.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
            // TODO: implement navigation to event editing form
          },
          backgroundColor: const Color.fromARGB(255, 29, 101, 255),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          autoClose: true,
          icon: Icons.edit,
        )
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
                      return Image.asset('assets/images/app_logo.png', fit: BoxFit.cover);
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
