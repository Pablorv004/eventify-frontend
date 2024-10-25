import 'package:eventify/domain/models/login_response.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/services/login_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final LoginService loginService;
  List<User> userList = [];
  User? currentUser;
  String? loginErrorMessage;

  UserProvider(this.loginService);


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

  Future<void> fetchAllUsers() async {

    // TODO: IMPLEMENT USER LOADING FROM API

    notifyListeners();
  }

  userLogout() => currentUser = null;
}