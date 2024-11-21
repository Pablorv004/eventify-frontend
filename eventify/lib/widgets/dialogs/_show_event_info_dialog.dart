import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/event.dart';
import 'package:flutter/material.dart';

void showEventDialogInfo(BuildContext context, Event event) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TITLE
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      event.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
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
                        event.imageUrl??'https://via.placeholder.com/150',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            
                // DIVIDER
                const Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Divider(
                    endIndent: 100,
                    indent: 100,
                    color: AppColors.amberOrange,
                    thickness: 3,
                  ),
                ),
                
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // DESCRIPTION
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            const Text('What\'s this event about?', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(event.description ?? 'No description provided',),
                          ]),
                        ),
                  
                        // START DATE
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            const Text('When does it start?', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(
                              '${event.startTime.toLocal().day}/${event.startTime.toLocal().month}/${event.startTime.toLocal().year}',
                            ),
                          ]),
                        ),
                        
                        // END DATE
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            const Text('When does it end?', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(
                              '${event.endTime?.toLocal().day}/${event.endTime?.toLocal().month}/${event.endTime?.toLocal().year}',
                            ),
                          ]),
                        ),
                  
                        // LOCATION
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            const Text('Where?', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(event.location ?? 'Not decided yet',),
                          ]),
                        ),
                            ],
                          ),
                  ),
                ),
                
            
                // DIVIDER
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 15),
                  child: Divider(
                    endIndent: 100,
                    indent: 100,
                    color: AppColors.amberOrange,
                    thickness: 3,
                  ),
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
                  child: const Text('Okay!'),
                )
              ],
            ),
          ));
    },
  );
}
