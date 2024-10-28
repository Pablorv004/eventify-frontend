import 'dart:convert';
import 'package:eventify/domain/models/fetch_response.dart';
import 'package:http/http.dart' as http;

class FetchService {
  Future<FetchResponse> fetchUsers(String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/users');

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
