import 'package:eventify/domain/models/event.dart';
import 'package:flutter/material.dart';

void showEventDialogInfo(BuildContext context, Event event) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TITLE
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('Event Information',
                    style: TextStyle(fontSize: 25)),
              ),

              // IMAGE
              Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Image.network(
                      event.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              
              // NAME
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: Text(event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),

              // START DATE
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(children: [
                  const Text('When does it start?', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(
                    '${event.startTime.toLocal().day}/${event.startTime.toLocal().month}/${event.startTime.toLocal().year}',
                  ),
                ]),
              ),
              
              // START DATE
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(children: [
                  const Text('When does it end?', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(
                    '${event.endTime?.toLocal().day}/${event.endTime?.toLocal().month}/${event.endTime?.toLocal().year}',
                  ),
                ]),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(children: [
                  const Text('Where will it be?', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(event.location ?? 'Not decided yet',),
                ]),
              ),

              // OKAY BUTTON
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Okey!'),
              )
            ],
          ));
    },
  );
}
