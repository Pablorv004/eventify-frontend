import 'package:eventify/domain/models/auth_response.dart';
import 'package:eventify/domain/models/fetch_response.dart';
import 'package:eventify/domain/models/user.dart';
import 'package:eventify/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final UserService userService;
  List<User> userList = [];
  User? currentUser;
  String? loginErrorMessage;
  String? registerErrorMessage; 
  String? fetchErrorMessage;
  String? validationErrorMessage;

  UserProvider(this.userService);
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
      AuthResponse loginResponse = await userService.login(email, password);

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
      final validationMethod = validationBoolean ? userService.activate : userService.deactivate;

      final validationResponse = await validationMethod(id, currentUser!.rememberToken ?? '');

      final errorMessage = validationBoolean ? 'Validation Failed' : 'Unvalidation Failed';

      validationErrorMessage = validationResponse.success ? null : validationResponse.data['error'] ?? errorMessage;
    } catch (error) {
      validationErrorMessage = 'Error: ${error.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> registerUser(String name, String email, String password, String confirmPassword) async {
    try {
      AuthResponse registerResponse = await userService.register(name, email, password, confirmPassword);

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
      FetchResponse fetchResponse = await userService.fetchUsers(token);

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
