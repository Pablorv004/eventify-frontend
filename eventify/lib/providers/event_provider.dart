import 'package:eventify/domain/models/event.dart';
import 'package:eventify/domain/models/http_responses/fetch_response.dart';
import 'package:eventify/services/event_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final EventService eventsService;
  List<Event> eventList = [];
  String? fetchErrorMessage;

  EventProvider(this.eventsService);

  /// Fetches a list of events from the server.
  ///
  /// This method retrieve a list of events.
  /// If the fetch is successful, it initializes `eventList` with the list of events and clears
  /// any existing error messages in `fetchErrorMessage`.
  Future<void> fetchEvents(String token) async {
    try {
      FetchResponse fetchResponse = await eventsService.fetchEvents(token);

      if (fetchResponse.success) {
        eventList = fetchResponse.data
            .map((event) => Event.fromFetchEventsJson(event))
            .toList();
        fetchErrorMessage = null;
      } else {
        fetchErrorMessage = fetchResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Fetching error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  // Fetches all events that haven't started yet.
  Future<void> fetchUpcomingEvents(String token) async {
    await fetchEvents(token);
    eventList = eventList
        .where((event) => event.startTime.isAfter(DateTime.now()))
        .toList();
  }

  //Sort events by time
  void sortEventsByTime() {
    eventList.sort((a, b) => a.startTime.compareTo(b.startTime));
  }
}
