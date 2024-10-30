import 'dart:convert';
import 'package:eventify/domain/models/auth_response.dart';
import 'package:eventify/domain/models/fetch_response.dart';
import 'package:http/http.dart' as http;

class UserService {
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

  Future<AuthResponse> login(String email, String password) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    return AuthResponse.fromJson(json.decode(response.body));
  }

  Future<AuthResponse> register(
      String name, String email, String password, String confirmPassword,
      String role) async {
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
        'role': role, // Ensure role is included here
      }),
    );

    return AuthResponse.fromJson(json.decode(response.body));
  }

  Future<AuthResponse> activate(int id, String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/activate');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'id': id}),
    );

    return AuthResponse.fromJson(json.decode(response.body));
  }

  Future<AuthResponse> deactivate(int id, String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/deactivate');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'id': id}),
    );

    return AuthResponse.fromJson(json.decode(response.body));
  }

  Future<AuthResponse> delete(int id, String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/deleteUser');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'id': id}),
    );

    return AuthResponse.fromJson(json.decode(response.body));
  }

  Future<AuthResponse> update(String name, int id, String token) async {
    final url = Uri.parse('https://eventify.allsites.es/public/api/updateUser');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'name': name, 'id': id}),
    );

    return AuthResponse.fromJson(json.decode(response.body));
  }
}
