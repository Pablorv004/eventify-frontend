import 'dart:convert';

import 'package:eventify/domain/models/http_responses/auth_response.dart';
import 'package:eventify/domain/models/http_responses/fetch_response.dart';
import 'package:http/http.dart' as http;

class EventService {
  Future<FetchResponse> fetchEvents(String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/events');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }

  Future<FetchResponse> fetchCategories(String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/categories');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }

  Future<FetchResponse> fetchEventsByUser(String token, int userId) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/eventsByUser?id=$userId');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }

  Future<AuthResponse> registerUserToEvent(String token, int userId, int eventId) async{
    final url = Uri.parse('https://eventify.allsites.es/public/api/registerEvent');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'user_id': userId.toString(),
        'event_id': eventId.toString(),
        'registered_at': DateTime.now().toString(),
      },
    );
    return AuthResponse.fromJson(json.decode(response.body));
}

  Future<AuthResponse> unregisterUserFromEvent(String token, int userId, int eventId) async{
    final url = Uri.parse('https://eventify.allsites.es/public/api/unregisterEvent');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: {
        'user_id': userId.toString(),
        'event_id': eventId.toString(),
      },
    );
    return AuthResponse.fromJson(json.decode(response.body));
  }
}