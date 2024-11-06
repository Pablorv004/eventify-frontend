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
  List<Category> categoryList = [];
  String? fetchErrorMessage;

  EventProvider(this.eventsService, this.authService);

  /// Fetches a list of events from the server.
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
        // Al inicio, mostramos solo los eventos futuros sin filtro
        filteredEventList = eventList.where((event) => event.startTime.isAfter(DateTime.now())).toList();
        fetchErrorMessage = null;
        sortEventsByTime(); // Ordenamos eventos futuros al iniciar
      } else {
        fetchErrorMessage = fetchResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Fetching error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// Filtra eventos que aún no han ocurrido
  void fetchUpcomingEvents() {
    filteredEventList = eventList.where((event) => event.startTime.isAfter(DateTime.now())).toList();
    sortEventsByTime();
    notifyListeners();
  }

  /// Filtra eventos por categoría
  void fetchEventsByCategory(String category) {
    filteredEventList = eventList
        .where((event) => event.category == category && event.startTime.isAfter(DateTime.now()))
        .toList();
    sortEventsByTime();
    notifyListeners();
  }

  /// Restablece el filtro para mostrar solo eventos futuros sin categoría
  void clearFilter() {
    fetchUpcomingEvents();
  }

  /// Ordena eventos por fecha y hora
  void sortEventsByTime() {
    filteredEventList.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Obtiene todas las categorías
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
