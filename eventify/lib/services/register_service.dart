import 'dart:convert';
import 'package:eventify/domain/models/register_response.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  Future<RegisterResponse> register(String name, String email, String password, String confirmPassword, {String role = 'u'}) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'c_password': confirmPassword,
        'role': role,
      }),
    );

    return RegisterResponse.fromJson(json.decode(response.body));
  }
}