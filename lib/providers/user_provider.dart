
import 'package:flutter/material.dart';
import 'package:travend/models/user.dart';

import '../pages/tab_management.dart';

class UserProvider with ChangeNotifier {
    User? _user;
    final TabManagement _tabManagement = const TabManagement();

    User get getUser => _user!;

    Future<void> refreshUser() async {
        User user = await _tabManagement.getUserInfo();
        _user = user;
        notifyListeners();
    }
}