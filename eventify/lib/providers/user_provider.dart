import 'package:eventify/domain/models/login_response.dart';
import 'package:eventify/domain/models/register_response.dart'; // Add this line
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/services/login_service.dart';
import 'package:eventify/services/register_service.dart'; // Add this line
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final LoginService loginService;
  final RegisterService registerService; // Add this line
  List<User> userList = [];
  User? currentUser;
  String? loginErrorMessage;
  String? registerErrorMessage; // Add this line

  UserProvider(this.loginService, this.registerService); // Update constructor

  Future<void> loginUser(String email, String password) async {
    try {
      LoginResponse loginResponse = await loginService.login(email, password);

      if (loginResponse.success) {
        currentUser = User.fromLoginJson(loginResponse.data);
        loginErrorMessage = null;
      } else {
        loginErrorMessage = loginResponse.data['error'] ?? 'Login Failed';
      }
    } catch (error) {
      loginErrorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> registerUser(String name, String email, String password, String confirmPassword) async {
    try {
      RegisterResponse registerResponse = await registerService.register(name, email, password, confirmPassword);

      if (registerResponse.success) {
        registerErrorMessage = null;
      } else {
        registerErrorMessage = registerResponse.data['error'] ?? 'Registration Failed';
      }
    } catch (error) {
      registerErrorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchAllUsers() async {
    // TODO: IMPLEMENT USER LOADING FROM API
    notifyListeners();
  }

  userLogout() => currentUser = null;
}