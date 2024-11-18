import 'dart:convert';

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
    final url = Uri.parse('https://eventify.allsites.es/public/api/events/user');

    final response = await http.get(
      url,
      headers: {
        'id': userId.toString(),
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return FetchResponse.fromJson(json.decode(response.body));
  }
}