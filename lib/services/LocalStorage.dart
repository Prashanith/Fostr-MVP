import 'package:fostr/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  SharedPreferences? _prefs;
  bool firstOpen = true;
  bool loggedIn = false;
  bool isClub = false;

  readPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    firstOpen = _prefs!.getBool(FIRST_OPEN) ?? true;
    loggedIn = _prefs!.getBool(LOGGED_IN) ?? false;
    isClub = _prefs!.getBool(USER_TYPE) ?? false;
  }

  setLoggedIn() {
    firstOpen = false;
    loggedIn = true;
    _prefs!.setBool(FIRST_OPEN, firstOpen);
    _prefs!.setBool(LOGGED_IN, loggedIn);
  }

  setUser() {
    isClub = false;
    _prefs!.setBool(USER_TYPE, false);
  }

  setClub() {
    isClub = true;
    _prefs!.setBool(USER_TYPE, true);
  }

  setLoggedOut() {
    firstOpen = false;
    loggedIn = false;
    _prefs!.setBool(FIRST_OPEN, firstOpen);
    _prefs!.setBool(LOGGED_IN, loggedIn);
  }
}
