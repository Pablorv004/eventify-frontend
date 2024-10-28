import 'package:eventify/domain/models/login_response.dart';
import 'package:eventify/domain/models/user.dart';
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

  /// Attempts to log in a user using the provided email and password credentials.
  ///
  /// This method calls the `login` method from `loginService` with the user's email and password.
  /// If login is successful, it initializes `currentUser` with the user's information and clears
  /// any existing error messages in `loginErrorMessage`.
  ///
  /// ### Parameters
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
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

  /// Toggles user validation based on the value of `validationBoolean`.
  ///
  /// This method dynamically selects between activating or deactivating a user's validation
  /// by using the `activate` or `deactivate` methods from `validationService`.
  ///
  /// ### Parameters
  /// - [id]: The unique identifier of the user whose validation status is to be modified.
  /// - [validationBoolean]: A boolean that specifies the operation to perform.
  ///   - `true`: activates the user
  ///   - `false`: deactivates the user
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
