import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/utils/pdf_util.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? startDate;
  DateTime? endDate;
  List<String> selectedEventTypes = [];

  Future<void> _downloadPdf(EventProvider eventProvider) async {
    final pdfDocument = await generatePdf(
        startDate, endDate, selectedEventTypes, eventProvider);
    final pdfFile = await writePdf(pdfDocument);
    await Printing.sharePdf(
        bytes: await pdfFile.readAsBytes(), filename: 'eventify_report.pdf');
  }

  Future<void> _sendPdfByEmail() async {
    // Send email functionality
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.read<EventProvider>();
    final eventTypes =
        eventProvider.categoryList.map((category) => category.name).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 160),
      child: Card(
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Generate Report',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Starts after...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      startDate = picked;
                    });
                  }
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(startDate != null
                        ? startDate.toString()
                        : 'Choose Date')),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ends before...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      endDate = picked;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      endDate != null ? endDate.toString() : 'Choose Date'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Event Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 230,
                child: ListView(
                  shrinkWrap: true,
                  children: eventTypes.map((type) {
                    return CheckboxListTile(
                      title: Text(type),
                      value: selectedEventTypes.contains(type),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedEventTypes.add(type);
                          } else {
                            selectedEventTypes.remove(type);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _downloadPdf(eventProvider),
                    child: const Text('Download PDF'),
                  ),
                  ElevatedButton(
                    onPressed: _sendPdfByEmail,
                    child: const Text('Send PDF by Email'),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Add some padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
