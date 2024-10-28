import 'package:eventify/domain/models/login_response.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/domain/models/validation_response.dart';
import 'package:eventify/services/login_service.dart';
import 'package:eventify/services/validation_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final LoginService loginService;
  final ValidationService validationService;
  List<User> userList = [];
  User? currentUser;
  String? loginErrorMessage;
  String? validationErrorMessage;

  UserProvider(this.loginService, this.validationService);

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

  Future<void> toggleUserValidation(int id, bool validationBoolean) async {
    try {
      final validationMethod = validationBoolean ? validationService.activate : validationService.deactivate;

      final validationResponse = await validationMethod(id, currentUser!.rememberToken ?? '');

      final errorMessage = validationBoolean ? 'Validation Failed' : 'Unvalidation Failed';

      validationErrorMessage = validationResponse.success ? null : validationResponse.data['error'] ?? errorMessage;
    } catch (error) {
      validationErrorMessage = 'Error: ${error.toString()}';
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
