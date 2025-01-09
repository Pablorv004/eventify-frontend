import 'package:eventify/domain/models/category.dart';
import 'package:eventify/domain/models/event.dart';
import 'package:eventify/domain/models/http_responses/auth_response.dart';
import 'package:eventify/domain/models/http_responses/fetch_response.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/providers/user_provider.dart';
import 'package:eventify/services/auth_service.dart';
import 'package:eventify/services/event_service.dart';
import 'package:flutter/foundation.dart' as flutter_foundation;

class EventProvider extends flutter_foundation.ChangeNotifier {
  final EventService eventsService;
  final AuthService authService;
  List<Event> eventList = [];
  List<Event> userEventList = [];
  List<Event> organizerEventList = [];
  List<Category> categoryList = [];
  String? fetchErrorMessage;
  Map<String, Map<String, int>> attendeesDataByCategory = {};

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
        eventList = fetchResponse.data
            .map((event) => Event.fromFetchEventsJson(event))
            .where((event) => event.startTime.isAfter(DateTime.now()))
            .where((event) =>
                !userEventList.any((userEvent) => userEvent.id == event.id))
            .toList();
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

  /// Fetches the amount of attendees per month of all events from the last 4 months excluding this one.
  /// This method calls the `fetchEventsByOrganizer` method from `eventsService` to retrieve the list of events made by the organizer.
  /// This method will be compared with the `fetchEventsByUser` method which will be inside a loop for each user using `fetchAllUsers` method from `userService`.
  /// If the fetching is successful, it'll return a map with the amount of attendees per month of all events by the organizer from the last 4 months excluding this one.
  Future<void> fetchAttendeesPerMonth(
      int organizerId, UserProvider userProvider) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }

      await initializeAttendeesDataByCategory();

      FetchResponse fetchResponse =
          await eventsService.fetchEventsByOrganizer(token, organizerId);

      if (fetchResponse.success) {
        List<Event> eventsFromOrganizer = fetchResponse.data
            .map((event) => Event.fromFetchEventsByOrganizerJson(event))
            .where((event) =>
                event.startTime.isAfter(DateTime(
                    DateTime.now().year, DateTime.now().month - 4, 1)) &&
                event.startTime.isBefore(
                    DateTime(DateTime.now().year, DateTime.now().month, 1)))
            .toList();
        print(eventsFromOrganizer);
        print(token);
        await userProvider.fetchAllUsers();
        for (User curruser in userProvider.userList) {
          await fetchEventsByUser(curruser.id);
          print("Accessing User: ${curruser.id}");
          for (Event eventFromOrganizer in eventsFromOrganizer) {
            for (Event eventFromUser in userEventList) {
              print("User Event ID: ${eventFromUser.id}, Organizer Event ID: ${eventFromOrganizer.id}. Are they the same?: ${eventFromUser.id == eventFromOrganizer.id}");
              if (eventFromUser.id == eventFromOrganizer.id) {
                print("Event that matches found for category: ${eventFromOrganizer.category!}");
                String category = eventFromOrganizer.category!;
                attendeesDataByCategory[category]![
                        eventFromOrganizer.startTime.month.toString()] =
                    attendeesDataByCategory[category]![
                            eventFromOrganizer.startTime.month.toString()]! +
                        1;
              }
            }
          }
        }
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

  Future<void> initializeAttendeesDataByCategory() async {
    await fetchCategories();
    for (Category category in categoryList) {
      if (category.name == 'Select a category') continue;
      attendeesDataByCategory[category.name] = {};
      for (int i = 1; i <= 4; i++) {
        DateTime month =
            DateTime(DateTime.now().year, DateTime.now().month - i, 1);
        attendeesDataByCategory[category.name]![month.month.toString()] = 0;
      }
    }
  }

  Map<String, int> getAttendeesDataForCategory(String category) {
    return attendeesDataByCategory[category] ?? {};
  }

  /// Fetches events by user.
  /// Has the user id as a parameter.
  /// This method calls the `fetchEventsByUser` method from `eventsService` to retrieve the list of events in which the user is registered.
  /// If fetching is successful, it updates the `eventList` and `filteredEventList` with the retrieved events.
  Future<void> fetchEventsByUser(int userId) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }
      FetchResponse fetchResponse =
          await eventsService.fetchEventsByUser(token, userId);
      if (fetchResponse.success) {
        userEventList = fetchResponse.data
            .map((event) => Event.fromFetchEventsByUserJson(event))
            .toList();

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

  /// Fetches events organized by a specific organizer.
  ///
  /// This method retrieves events for a given organizer by their ID. It first
  /// attempts to get an authentication token. If the token is not found, it sets
  /// an error message and notifies listeners.
  Future<void> fetchEventsByOrganizer(int organizerId) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }
      FetchResponse fetchResponse =
          await eventsService.fetchEventsByOrganizer(token, organizerId);
      if (fetchResponse.success) {
        organizerEventList = fetchResponse.data
            .map((event) => Event.fromFetchEventsByOrganizerJson(event))
            .toList();
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
    fetchEvents();
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
  void fetchEventsByCategory(String category) async {
    await fetchEvents();
    eventList = eventList.where((event) => event.category == category).toList();
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
    eventList.sort((a, b) => a.startTime.compareTo(b.startTime));
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

  /// Registers a user to an event.
  /// Has the user id and event id as parameters.
  /// This method calls the `registerUserToEvent` method from `eventsService` to register the user to the event.
  /// If registration is successful, it updates the `userEventList` with the registered event.
  Future<void> registerUserToEvent(int userId, int eventId) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }

      AuthResponse authResponse =
          await eventsService.registerUserToEvent(token, userId, eventId);

      if (authResponse.success) {
        await fetchEventsByUser(userId);
        await fetchEvents();
        sortEventsByTime();
        fetchErrorMessage = null;
      } else {
        fetchErrorMessage = authResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Registration error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// Unregisters a user from an event.
  /// Has the user id and event id as parameters.
  /// This method calls the `unregisterUserFromEvent` method from `eventsService` to unregister the user from the event.
  /// If unregistration is successful, it removes the event from the `userEventList`.
  Future<void> unregisterUserFromEvent(int userId, int eventId) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }

      AuthResponse authResponse =
          await eventsService.unregisterUserFromEvent(token, userId, eventId);

      if (authResponse.success) {
        await fetchEventsByUser(userId);
        await fetchEvents();
        fetchErrorMessage = null;
      } else {
        fetchErrorMessage = authResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Unregistration error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> createEvent(Event event) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }
      AuthResponse authResponse = await eventsService.createEvent(token, event);
      if (authResponse.success) {
        await fetchEventsByOrganizer(event.organizerId!);
        fetchErrorMessage = null;
      } else {
        fetchErrorMessage = authResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }
      AuthResponse authResponse = await eventsService.updateEvent(token, event);
      if (authResponse.success) {
        await fetchEventsByOrganizer(event.organizerId!);
        fetchErrorMessage = null;
      } else {
        fetchErrorMessage = authResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      String? token = await authService.getToken();
      if (token == null) {
        fetchErrorMessage = 'Token not found';
        notifyListeners();
        return;
      }

      FetchResponse authResponse =
          await eventsService.deleteEvent(token, event.id);

      if (authResponse.success) {
        await fetchEventsByOrganizer(event.organizerId!);
        fetchErrorMessage = null;
      } else {
        fetchErrorMessage = authResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }
}
