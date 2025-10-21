import 'package:shared_preferences/shared_preferences.dart';

class DataMange {
  SharedPreferences? prefs;

  DataMange() {
    init();
  }

  Future<void> init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  Future<int> getDataInt(String name) async {
    if (prefs == null) {
      await init();
    }
    return prefs!.getInt(name) ?? 0;
  }

  void setDataInt(String name, int value) async {
    if (prefs == null) {
      await init();
    }
    prefs!.setInt(name, value);
  }
}
