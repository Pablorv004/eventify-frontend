import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:eventify/domain/models/validation_response.dart';

class ValidationService {
  Future<ValidationResponse> activate(int id, String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/activate');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode({
        'id': id
      }),
    );
    
    return ValidationResponse.fromJson(json.decode(response.body));
  }

  Future<ValidationResponse> deactivate(int id, String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/deactivate');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode({
        'id': id
      }),
    );
    
    return ValidationResponse.fromJson(json.decode(response.body));
  }
}