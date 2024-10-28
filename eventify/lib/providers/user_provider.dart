import 'package:eventify/domain/models/fetch_response.dart';
import 'package:eventify/domain/models/login_response.dart';
import 'package:eventify/domain/models/register_response.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/services/fetch_service.dart';
import 'package:eventify/services/login_service.dart';
import 'package:eventify/services/register_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final LoginService loginService;
  final RegisterService registerService; 
  final FetchService fetchService;
  List<User> userList = [];
  User? currentUser;
  String? loginErrorMessage;
  String? registerErrorMessage; 
  String? fetchErrorMessage;

  UserProvider(this.loginService, this.registerService, this.fetchService);

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

  Future<void> fetchAllUsers(String token) async {
    try {
      FetchResponse fetchResponse = await fetchService.fetchUsers(token);

      if (fetchResponse.success) {
        userList = fetchResponse.data
            .map((userJson) => User.fromFetchUsersJson(userJson)).toList();
        fetchErrorMessage = null;
      } else {
        fetchErrorMessage = fetchResponse.message;
      }
    } catch (error) {
      fetchErrorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  userLogout() => currentUser = null;
}