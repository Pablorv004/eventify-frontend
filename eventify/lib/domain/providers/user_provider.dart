import 'package:eventify/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{

  List<User> userList = [];

  // TODO: IMPLEMENT API METHODS

  Future<void> getUsers() async {

    // TODO: IMPLEMENT USER LOADING FROM API

    notifyListeners();
  }
}