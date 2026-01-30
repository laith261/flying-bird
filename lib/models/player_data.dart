import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:games_services/games_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerData extends ChangeNotifier {
  static const String _storageKey = 'PlayerData';

  int _highScore;
  int _coins;
  String _selectedTrail;
  List<String> _purchasedTrails;

  int get highScore => _highScore;
  int get coins => _coins;
  String get selectedTrail => _selectedTrail;
  List<String> get purchasedTrails => List.unmodifiable(_purchasedTrails);

  PlayerData({
    int highScore = 0,
    int coins = 0,
    String selectedTrail = 'none',
    List<String> purchasedTrails = const ['none'],
  }) : _highScore = highScore,
       _coins = coins,
       _selectedTrail = selectedTrail,
       _purchasedTrails = purchasedTrails;

  // --- Logic Methods ---

  Future<void> addCoins(int amount) async {
    _coins += amount;
    notifyListeners();
    await save();
  }

  Future<bool> subtractCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
      await save();
      return true;
    }
    return false;
  }

  Future<void> updateHighScore(int score) async {
    if (score > _highScore) {
      _highScore = score;
      notifyListeners();
      await save();
    }
  }

  Future<void> unlockTrail(String trailId) async {
    if (!_purchasedTrails.contains(trailId)) {
      _purchasedTrails.add(trailId);
      notifyListeners();
      await save();
    }
  }

  Future<void> equipTrail(String trailId) async {
    if (_selectedTrail != trailId) {
      _selectedTrail = trailId;
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

    // If local is empty, try loading from cloud (First install scenario)
    if (jsonStr == null || jsonStr.isEmpty) {
      try {
        final String? cloudData = await GamesServices.loadGame(
          name: _storageKey,
        );
        if (cloudData != null && cloudData.isNotEmpty) {
          jsonStr = cloudData;
          // Sync back to local
          await _prefs.setString(_storageKey, cloudData);
        }
      } catch (e) {
        debugPrint('Cloud Load failed: $e');
      }
    }

    if (jsonStr == null || jsonStr.isEmpty) {
      return PlayerData();
    }

    try {
      return PlayerData.fromJson(jsonDecode(jsonStr));
    } catch (e) {
      return PlayerData();
    }
  }

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      highScore: json['highScore'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      selectedTrail: json['selectedTrail'] as String? ?? 'none',
      purchasedTrails:
          (json['purchasedTrails'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['none'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highScore': _highScore,
      'coins': _coins,
      'selectedTrail': _selectedTrail,
      'purchasedTrails': _purchasedTrails,
    };
  }

  // Debug/Legacy copyWith if needed
  PlayerData copyWith({
    int? highScore,
    int? coins,
    String? selectedTrail,
    List<String>? purchasedTrails,
  }) {
    return PlayerData(
      highScore: highScore ?? _highScore,
      coins: coins ?? _coins,
      selectedTrail: selectedTrail ?? _selectedTrail,
      purchasedTrails: purchasedTrails ?? _purchasedTrails,
    );
  }
}
