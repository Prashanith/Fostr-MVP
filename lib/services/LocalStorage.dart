import 'package:fostr/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  SharedPreferences? _prefs;
  bool firstOpen = true;
  bool loggedIn = false;

  readPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    firstOpen = _prefs!.getBool(FIRST_OPEN) ?? true;
    loggedIn = _prefs!.getBool(LOGGED_IN) ?? false;
  }

  setLoggedIn() {
    firstOpen = false;
    loggedIn = true;
    _prefs!.setBool(FIRST_OPEN, firstOpen);
    _prefs!.setBool(LOGGED_IN, loggedIn);
  }

  setLoggedOut() {
    firstOpen = false;
    loggedIn = false;
    _prefs!.setBool(FIRST_OPEN, firstOpen);
    _prefs!.setBool(LOGGED_IN, loggedIn);
  }
}
