import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/event.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/widgets/dialogs/_show_event_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final EventProvider eventProvider;
  const EventCard({super.key, required this.event, required this.eventProvider});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [ Card(
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: chooseCardBorderColor(),
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    event.imageUrl??'https://via.placeholder.com/150',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      event.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Row(children: [
                        const Icon(Icons.calendar_today, size: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            '${event.startTime.toLocal().day}/${event.startTime.toLocal().month}/${event.startTime.toLocal().year}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ]),
              
                      const Spacer(),
              
                      // Time row
                      Row(children: [
                        const Icon(Icons.access_time, size: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            'Starts at: ${event.startTime.toLocal().hour}:${event.startTime.toLocal().minute}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: eventProvider.userEventList.contains(event) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      backgroundColor: eventProvider.userEventList.contains(event) ? const Color.fromARGB(255, 241, 84, 97) : const Color.fromARGB(255, 114, 145, 247),
                    ),
                    onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(eventProvider.userEventList.contains(event) ? 'Unregister from Event' : 'Register for Event'),
                          content: Text(eventProvider.userEventList.contains(event)
                              ? 'Are you sure you want to unregister from this event?'
                              : 'Are you sure you want to register for this event?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                User user = context.read<UserProvider>().currentUser!;
                                eventProvider.userEventList.contains(event)
                                    ? eventProvider.unregisterUserFromEvent(user.id, event.id)
                                    : eventProvider.registerUserToEvent(user.id, event.id);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(eventProvider.userEventList.contains(event) ? 'I can\'t go!' : 'Count with me!'),
                        const SizedBox(width: 5),
                        Text(eventProvider.userEventList.contains(event) ? '😔' : '😀'),
                      ],
                    ),
                  ),
            
                  const SizedBox(width: 5),
                  
                  if(eventProvider.userEventList.contains(event))
                    FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        backgroundColor: const Color.fromARGB(255, 114, 145, 247),
                      ),
                      onPressed: (){
                        showEventDialogInfo(context, event);
                      },
                      child: const Text('More Info')
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),

      Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: chooseCardBorderColor(),
              width: 3.0,
            ),
          ),
          child: Center(
            child: Icon(chooseIcon(), color: chooseCardBorderColor(), size: 45),
          ),
        ),
      )
    ]);
  }

  chooseCardBorderColor() {
    if (event.category == 'Music') {
      return AppColors.musicColor;
    } else if (event.category == 'Sport') {
      return AppColors.sportColor;
    } else if (event.category == 'Technology') {
      return AppColors.technologyColor;
    } else {
      return const Color.fromARGB(255, 168, 168, 168);
    }
  }
  
  IconData? chooseIcon() {
    if (event.category == 'Music') {
      return Icons.music_note;
    } else if (event.category == 'Sport') {
      return Icons.sports_basketball;
    } else if (event.category == 'Technology') {
      return Icons.tablet_android;
    } else {
      return Icons.question_mark_outlined;
    }
  }
}
