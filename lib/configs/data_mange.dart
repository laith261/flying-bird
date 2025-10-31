import 'package:game/configs/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';

class DataMange {
  SharedPreferences? prefs;

  DataMange() {
    init();
  }

  Future<void> init() async => prefs ??= await SharedPreferences.getInstance();

  Future<int> getDataInt({String? name}) async {
    if (prefs == null) await init();

    var savedGame = int.parse(await Functions.loadScore() ?? "0");
    var highest = prefs!.getInt(name ?? Consts.savedDataName) ?? 0;
    if (savedGame > highest) {
      highest = savedGame;
    }
    if (highest > savedGame) {
      Functions.saveScore(highest);
    }
    return highest;
  }

  void setDataInt({String? name, required int value}) async {
    if (prefs == null) await init();
    Functions.saveScore(value);
    prefs!.setInt(name ?? Consts.savedDataName, value);
  }
}
