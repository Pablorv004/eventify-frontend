import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:eventify/providers/event_provider.dart';
import 'package:path/path.dart' as path;

Future<pw.Document> generatePdf(DateTime? startDate, DateTime? endDate,
  List<String> eventTypes, EventProvider eventProvider) async {
  final pdf = pw.Document();

  // Fetch events from the provider
  final events = eventProvider.eventList.where((event) {
    final matchesDateRange =
      (startDate == null || event.startTime.isAfter(startDate)) &&
        (endDate == null || event.startTime.isBefore(endDate));
    final matchesEventType =
      eventTypes.isEmpty || eventTypes.contains(event.category);
    return matchesDateRange && matchesEventType;
  }).toList();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Report',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Generated on: ${DateTime.now()}',
              style: const pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 16),
            pw.Text('Start Date: ${startDate?.toString() ?? 'Undisclosed'}'),
            pw.Text('End Date: ${endDate?.toString() ?? 'Undisclosed'}'),
            pw.SizedBox(height: 16),
            pw.Text('Event Types: ${eventTypes.join(', ')}'),
            pw.SizedBox(height: 16),
            pw.Divider(),
            pw.Text('Events:',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(event.title,
                      style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Category: ${event.category}'),
                      pw.Text('Start Time: ${event.startTime}'),
                      pw.Text('End Time: ${event.endTime!}'),
                    ],
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Divider(borderStyle: pw.BorderStyle.dashed),
                  ],
                );
              },
            ),
          ],
        );
      },
    ),
  );

  return pdf;
}

Future<File> writePdf(pw.Document pdf) async {
  final downloadsDirectory = Directory('/storage/emulated/0/Download');
  final formattedDate = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}';
  final filePath = path.join(downloadsDirectory.path, 'eventifyreport_$formattedDate.pdf');
  final fileDirectory = Directory(path.dirname(filePath));

  if (!await fileDirectory.exists()) {
    await fileDirectory.create(recursive: true);
  }

  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return file;
}
