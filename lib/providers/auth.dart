import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier { //extend provider
  late String _token;
  late DateTime? _expiryDate = null;
  late String _userId;
  late Timer? _authTimer = null;
  late String _Role;

  bool get isAuth { //tentukan token ada atau tidak
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAJLOukbe-g5xNXy1b3sPvNZO8_Su1SGXI');
    final roleUrl =
        ('https://toyshopapp-965b2-default-rtdb.asia-southeast1.firebasedatabase.app/user.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(json.decode(response.body)); // For debug console...
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken']; // Get the id token...
      _userId = responseData['localId']; // Get the user id
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      if (urlSegment == "signUp") {
        final roleResponse = await http.post(
          Uri.parse(roleUrl),
          body: json.encode({
            'userId': userId,
            'role': _Role,
          }),
        );
      }

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      print("Debug => Token value = " + _token);
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String()
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    //singup
    return _authenticate(email, password, 'signUp');
  }

  Future<void> accRole(String Role) async {
    //untuk save role acc
    _Role = Role;
  }

  Future<void> login(String email, String password) async {
    //
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() async {
    //logout function, clear data
    _token = '';
    _userId = '';
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    // final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    // _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    // _authTimer = Timer(Duration(seconds: 8), logout);
  }
}
