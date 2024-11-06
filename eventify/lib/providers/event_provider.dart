import 'package:eventify/domain/models/event.dart';
import 'package:eventify/domain/models/category.dart';
import 'package:eventify/domain/models/http_responses/fetch_response.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:flutter/foundation.dart' as flutter_foundation;

class EventProvider extends flutter_foundation.ChangeNotifier {
  final EventService eventsService;
  final AuthService authService;
  List<Event> eventList = [];
  List<Category> categoryList = [];
  String? fetchErrorMessage;

  EventProvider(this.eventsService, this.authService);

  /// Fetches a list of events from the server.
  ///
  /// This method retrieve a list of events.
  /// If the fetch is successful, it initializes `eventList` with the list of events and clears
  /// any existing error messages in `fetchErrorMessage`.
  Future<void> fetchEvents() async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }

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
  Future<void> fetchUpcomingEvents() async {
    await fetchEvents();
    eventList = eventList
        .where((event) => event.startTime.isAfter(DateTime.now()))
        .toList();
  }

  //Sort events by time
  void sortEventsByTime() {
    eventList.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }

      FetchResponse fetchResponse = await eventsService.fetchCategories(token);

      if (fetchResponse.success) {
        categoryList = fetchResponse.data
            .map((category) => Category.fromFetchCategoriesJson(category))
            .toList();
        fetchErrorMessage = null;
        
      } else {
        fetchErrorMessage = fetchResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Fetching categories error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }
}
