import 'dart:convert';
import 'package:eventify/domain/models/login_response.dart';
import 'package:http/http.dart' as http;

class LoginService {

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
}