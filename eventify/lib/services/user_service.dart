import 'dart:convert';
import 'package:eventify/domain/models/fetch_response.dart';
import 'package:eventify/domain/models/login_response.dart';
import 'package:eventify/domain/models/register_response.dart';
import 'package:eventify/domain/models/validation_response.dart';
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

  Future<LoginResponse> login(String email, String password) async {
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

    
    return LoginResponse.fromJson(json.decode(response.body));
    
  }

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