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
}