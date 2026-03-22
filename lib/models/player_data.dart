import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:game/component/skins/skinEnum.dart';
import 'package:games_services/games_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerData extends ChangeNotifier {
  static const String _storageKey = 'PlayerData';

  int _highScore;
  int _coins;
  String _selectedTrail;
  Skins _selectedSkin;
  List<String> _purchasedTrails;
  int _lastModified;
  int _shields;
  int _luckyDay = 0;
  List<String> _purchasedSkins;

  int get highScore => _highScore;
  int get coins => _coins;
  int get shields => _shields;
  int get luckyDay => _luckyDay;
  String get selectedTrail => _selectedTrail;
  Skins get selectedSkin => _selectedSkin;
  List<String> get purchasedTrails => List.unmodifiable(_purchasedTrails);
  List<String> get purchasedSkins => List.unmodifiable(_purchasedSkins);
  int get lastModified => _lastModified;

  PlayerData({
    int highScore = 0,
    int coins = 0,
    String selectedTrail = 'none',
    Skins selectedSkin = Skins.bird,
    List<String> purchasedTrails = const ['none'],
    int lastModified = 0,
    int shields = 0,
    int luckyDay = 0,
    List<String> purchasedSkins = const ['bird'],
  }) : _highScore = highScore,
       _coins = coins,
       _selectedTrail = selectedTrail,
       _selectedSkin = selectedSkin,
       _purchasedTrails = purchasedTrails,
       _purchasedSkins = purchasedSkins,
       _lastModified = lastModified,
       _shields = shields,
       _luckyDay = luckyDay;

  // --- Logic Methods ---

  Future<void> addShield(int amount) async {
    _shields += amount;
    _lastModified = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
    await save();
  }

  Future<bool> useShield() async {
    if (_shields > 0) {
      _shields--;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      await save();
      return true;
    }
    return false;
  }

  Future<void> addLuckyDay(int amount) async {
    _luckyDay += amount;
    _lastModified = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
    await save();
  }

  Future<bool> useLuckyDay() async {
    if (_luckyDay > 0) {
      _luckyDay--;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      await save();
      return true;
    }
    return false;
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    _lastModified = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
    await save();
  }

  Future<bool> subtractCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      await save();
      return true;
    }
    return false;
  }

  Future<void> updateHighScore(int score) async {
    if (score > _highScore) {
      _highScore = score;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      await save();
    }
  }

  Future<void> unlockTrail(String trailId) async {
    if (!_purchasedTrails.contains(trailId)) {
      _purchasedTrails.add(trailId);
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      await save();
    }
  }

  Future<void> unlockSkin(String skinName) async {
    if (!_purchasedSkins.contains(skinName)) {
      _purchasedSkins.add(skinName);
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      await save();
    }
  }

  Future<void> equipTrail(String trailId) async {
    if (_selectedTrail != trailId) {
      _selectedTrail = trailId;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      await save();
    }
  }

  Future<void> equipSkin(Skins skin) async {
    if (_selectedSkin != skin) {
      _selectedSkin = skin;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      await save();
    }
  }

  // --- Persistence ---

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      await GamesServices.signIn();
    } catch (e) {
      debugPrint('Cloud Sign-In failed: $e');
    }
  }

  Future<void> save() async {
    final String data = jsonEncode(toJson());
    // Local Save
    await _prefs.setString(_storageKey, data);

    // Cloud Save
    try {
      await GamesServices.saveGame(name: _storageKey, data: data);
    } catch (e) {
      debugPrint('Cloud Save failed: $e');
    }
  }

  static Future<PlayerData> load() async {
    String? jsonStr = _prefs.getString(_storageKey);
    final PlayerData localData = (jsonStr != null && jsonStr.isNotEmpty)
        ? PlayerData.fromJson(jsonDecode(jsonStr))
        : PlayerData();

    PlayerData? cloudData;
    try {
      final String? cloudJson = await GamesServices.loadGame(name: _storageKey);
      if (cloudJson != null && cloudJson.isNotEmpty) {
        cloudData = PlayerData.fromJson(jsonDecode(cloudJson));
      }
    } catch (e) {
      debugPrint('Cloud Load failed: $e');
    }

    if (cloudData == null) {
      return localData;
    }

    // Compare timestamps (Last Write Wins)
    if (localData.lastModified >= cloudData.lastModified) {
      // Local is newer or equal
      if (localData.lastModified > cloudData.lastModified) {
        debugPrint('Local data is newer. Overwriting Cloud.');
        try {
          await GamesServices.saveGame(
            name: _storageKey,
            data: jsonEncode(localData.toJson()),
          );
        } catch (e) {
          debugPrint('Failed to sync Local to Cloud: $e');
        }
      }
      return localData;
    } else {
      // Cloud is newer
      debugPrint('Cloud data is newer. Overwriting Local.');
      await _prefs.setString(_storageKey, jsonEncode(cloudData.toJson()));
      return cloudData;
    }
  }

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      highScore: json['highScore'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      selectedTrail: json['selectedTrail'] as String? ?? 'none',
      selectedSkin: Skins.values.firstWhere(
        (e) => e.name == (json['selectedSkin'] as String?),
        orElse: () => Skins.bird,
      ),
      purchasedTrails:
          (json['purchasedTrails'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['none'],
      lastModified: json['lastModified'] as int? ?? 0,
      shields: json['shields'] as int? ?? 0,
      luckyDay: json['luckyDay'] as int? ?? 0,
      purchasedSkins:
          (json['purchasedSkins'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['bird'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highScore': _highScore,
      'coins': _coins,
      'shields': _shields,
      'luckyDay': _luckyDay,
      'selectedTrail': _selectedTrail,
      'selectedSkin': _selectedSkin.name,
      'purchasedTrails': _purchasedTrails,
      'purchasedSkins': _purchasedSkins,
      'lastModified': _lastModified,
    };
  }

  // Debug/Legacy copyWith if needed
  PlayerData copyWith({
    int? highScore,
    int? coins,
    String? selectedTrail,
    List<String>? purchasedTrails,
    List<String>? purchasedSkins,
    int? lastModified,
    int? shields,
    int? luckyDay,
    Skins? selectedSkin,
  }) {
    return PlayerData(
      highScore: highScore ?? _highScore,
      coins: coins ?? _coins,
      shields: shields ?? _shields,
      luckyDay: luckyDay ?? _luckyDay,
      selectedTrail: selectedTrail ?? _selectedTrail,
      selectedSkin: selectedSkin ?? _selectedSkin,
      purchasedTrails: purchasedTrails ?? _purchasedTrails,
      purchasedSkins: purchasedSkins ?? _purchasedSkins,
      lastModified: lastModified ?? _lastModified,
    );
  }
}
