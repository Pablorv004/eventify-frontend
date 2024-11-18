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
  List<Event> filteredEventList = [];
  List<Event> userEventList = [];
  List<Category> categoryList = [];
  String? fetchErrorMessage;


  EventProvider(this.eventsService, this.authService);

  /// Fetches all events.
  ///
  /// This method calls the `fetchEvents` method from `eventsService` to retrieve the list of events.
  /// If fetching is successful, it updates the `eventList` and `filteredEventList` with the retrieved events.
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
        eventList = fetchResponse.data.map((event) => Event.fromFetchEventsJson(event)).toList();
        
        // Only show events that have not happened yet
        filteredEventList = eventList.where((event) => event.startTime.isAfter(DateTime.now())).toList();
        fetchErrorMessage = null;
        sortEventsByTime();
      } else {
        fetchErrorMessage = fetchResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Fetching error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// Fetches events by user.
  /// Has the user id as a parameter.
  /// This method calls the `fetchEventsByUser` method from `eventsService` to retrieve the list of events created by the user.
  /// If fetching is successful, it updates the `eventList` and `filteredEventList` with the retrieved events.
  Future <void> fetchEventsByUser(int userId) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }

      FetchResponse fetchResponse = await eventsService.fetchEventsByUser(token, userId);

      if (fetchResponse.success) {
        eventList = fetchResponse.data.map((event) => Event.fromFetchEventsJson(event)).toList();
        
        // Only show events that have not happened yet
        userEventList = eventList.where((event) => event.startTime.isAfter(DateTime.now())).toList();
        fetchErrorMessage = null;
        sortEventsByTime();
      } else {
        fetchErrorMessage = fetchResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Fetching error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }
  

  /// Fetches upcoming events.
  ///
  /// This method filters the `eventList` to only include events that have not happened yet
  /// and updates the `filteredEventList`.
  void fetchUpcomingEvents() {
    filteredEventList = eventList.where((event) => event.startTime.isAfter(DateTime.now())).toList();
    sortEventsByTime();
    notifyListeners();
  }

  /// Fetches events by category.
  ///
  /// This method filters the `eventList` to only include events that belong to the specified category
  /// and have not happened yet, and updates the `filteredEventList`.
  ///
  /// ### Parameters
  /// - [category]: The category to filter events by.
  void fetchEventsByCategory(String category) {
    filteredEventList = eventList
        .where((event) => event.category == category && event.startTime.isAfter(DateTime.now()))
        .toList();
    sortEventsByTime();
    notifyListeners();
  }

  /// Clears the current filter and fetches upcoming events.
  ///
  /// This method resets the `filteredEventList` to include all upcoming events.
  void clearFilter() {
    fetchUpcomingEvents();
  }

  /// Sorts events by time.
  ///
  /// This method sorts the `filteredEventList` by the start time of the events in ascending order.
  void sortEventsByTime() {
    filteredEventList.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Fetches all categories.
  ///
  /// This method calls the `fetchCategories` method from `eventsService` to retrieve the list of categories.
  /// If fetching is successful, it updates the `categoryList` with the retrieved categories.
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
        categoryList = fetchResponse.data.map((category) => Category.fromFetchCategoriesJson(category)).toList();
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