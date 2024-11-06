import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/event.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [ Card(
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
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
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    event.imageUrl,
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
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            child: Icon(chooseIcon(), color: chooseCardBorderColor(), size: 52),
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
