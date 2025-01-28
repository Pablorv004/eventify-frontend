import 'package:eventify/config/app_colors.dart';
import 'package:eventify/domain/models/event.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

void showMarkerEventDialogInfo(BuildContext context, Event event, Function(LatLng, String) onGoPressed) {
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
                    event.imageUrl ?? 'https://via.placeholder.com/150',
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
              height: MediaQuery.of(context).size.height * 0.15,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // START DATE
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('Starts at:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.amberOrange)),
                        Text(
                          '${event.startTime.toLocal().day}/${event.startTime.toLocal().month}/${event.startTime.toLocal().year} - ${event.startTime.toLocal().hour}:${event.startTime.toLocal().minute}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ]),
                    ),

                    // END DATE
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('Ends at:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.amberOrange)),
                        Text(
                          '${event.endTime?.toLocal().day}/${event.endTime?.toLocal().month}/${event.endTime?.toLocal().year} - ${event.endTime?.toLocal().hour}:${event.endTime?.toLocal().minute}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
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

            // IMPLEMENT GO BUTTONS HERE
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(Icons.directions_car),
                      label: const Text('Go!'),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onGoPressed(LatLng(event.latitude!, event.longitude!), 'driving-car');
                      },
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.directions_walk),
                      label: const Text('Go!'),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onGoPressed(LatLng(event.latitude!, event.longitude!), 'foot-walking');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ));
    },
  );
}
