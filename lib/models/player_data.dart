import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:game/component/skins/skin_enum.dart';
import 'package:games_services/games_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerInfo extends ChangeNotifier {
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
  DateTime? _lastLoginDate;
  int _rewardProgress;
  String? _playerId;

  int get highScore => _highScore;
  int get coins => _coins;
  int get shields => _shields;
  int get luckyDay => _luckyDay;
  DateTime get lastLoginDate =>
      _lastLoginDate ?? DateTime.fromMillisecondsSinceEpoch(0);
  int get rewardProgress => _rewardProgress;
  String get selectedTrail => _selectedTrail;
  Skins get selectedSkin => _selectedSkin;
  List<String> get purchasedTrails => List.unmodifiable(_purchasedTrails);
  List<String> get purchasedSkins => List.unmodifiable(_purchasedSkins);
  int get lastModified => _lastModified;
  String? get playerId => _playerId;

  PlayerInfo({
    int highScore = 0,
    int coins = 0,
    String selectedTrail = 'none',
    Skins selectedSkin = Skins.bird,
    List<String> purchasedTrails = const ['none'],
    int lastModified = 0,
    int shields = 0,
    int luckyDay = 0,
    List<String> purchasedSkins = const ['Bird'],
    DateTime? lastLoginDate,
    int rewardProgress = 0,
    String? playerId,
  }) : _highScore = highScore,
       _coins = coins,
       _selectedTrail = selectedTrail,
       _selectedSkin = selectedSkin,
       _purchasedTrails = List.from(purchasedTrails),
       _purchasedSkins = List.from(purchasedSkins),
       _lastModified = lastModified,
       _shields = shields,
       _luckyDay = luckyDay,
       _lastLoginDate = lastLoginDate,
       _rewardProgress = rewardProgress,
       _playerId = playerId;

  // --- Logic Methods ---

  Future<void> runBatched(List<Future<void> Function()> actions) async {
    try {
      for (final action in actions) {
        await action();
      }
    } finally {
      await save();
    }
  }

  Future<void> addShield(int amount) async {
    _shields += amount;
    _lastModified = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  Future<bool> useShield() async {
    if (_shields > 0) {
      _shields--;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> addLuckyDay(int amount) async {
    _luckyDay += amount;
    _lastModified = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  Future<bool> useLuckyDay() async {
    if (_luckyDay > 0) {
      _luckyDay--;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    _lastModified = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  Future<bool> subtractCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<void> updateHighScore(int score) async {
    if (score > _highScore) {
      _highScore = score;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
    }
  }

  Future<void> unlockTrail(String trailId) async {
    if (!_purchasedTrails.contains(trailId)) {
      _purchasedTrails.add(trailId);
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
    }
  }

  Future<void> unlockSkin(String skinName) async {
    if (!_purchasedSkins.contains(skinName)) {
      _purchasedSkins.add(skinName);
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
    }
  }

  Future<void> equipTrail(String trailId) async {
    if (_selectedTrail != trailId) {
      _selectedTrail = trailId;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
    }
  }

  Future<void> equipSkin(Skins skin) async {
    if (_selectedSkin != skin) {
      _selectedSkin = skin;
      _lastModified = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
    }
  }

  Future<void> updateLastLoginDate(DateTime date) async {
    _lastLoginDate = date;
    _lastModified = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  Future<void> updateRewardProgress(int progress) async {
    _rewardProgress = progress;
    _lastModified = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  void updateFrom(PlayerInfo other) {
    _highScore = other.highScore;
    _coins = other.coins;
    _selectedTrail = other.selectedTrail;
    _selectedSkin = other.selectedSkin;
    _purchasedTrails = List.from(other.purchasedTrails);
    _purchasedSkins = List.from(other.purchasedSkins);
    _lastModified = other.lastModified;
    _shields = other.shields;
    _luckyDay = other.luckyDay;
    _lastLoginDate = other.lastLoginDate;
    _rewardProgress = other.rewardProgress;
    _playerId = other.playerId;
    notifyListeners();
  }

  // --- Persistence ---

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    try {
      await GameAuth.signIn();
    } catch (e) {
      debugPrint('Cloud Sign-In failed: $e');
    }
  }

  Future<void> save() async {
    if (_playerId == null) {
      try {
        _playerId = await GamesServices.getPlayerID();
      } catch (e) {
        debugPrint('Failed to get player ID for save: $e');
      }
    }

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

  static Future<PlayerInfo> load() async {
    String? currentPlayerId;
    try {
      currentPlayerId = await GamesServices.getPlayerID();
    } catch (e) {
      debugPrint('Error getting player ID: $e');
    }

    String? jsonStr = _prefs.getString(_storageKey);
    PlayerInfo? localData;

    if (jsonStr != null && jsonStr.isNotEmpty) {
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      final String? storedPlayerId = json['playerId'] as String?;

      // Allow using local data if playerId matches, or if local data is "guest" (null)
      // and we want to associate it with the newly signed-in account.
      if (storedPlayerId == currentPlayerId ||
          (storedPlayerId == null && currentPlayerId != null)) {
        localData = PlayerInfo.fromJson(json);
        // If we are claiming guest data, set the playerId now
        if (storedPlayerId == null && currentPlayerId != null) {
          localData._playerId = currentPlayerId;
        }
      } else {
        debugPrint('Local data belongs to a different account. Ignoring.');
      }
    }

    localData ??= PlayerInfo(playerId: currentPlayerId);

    PlayerInfo? cloudData;
    try {
      final String? cloudJson = await GamesServices.loadGame(name: _storageKey);
      if (cloudJson != null && cloudJson.isNotEmpty) {
        cloudData = PlayerInfo.fromJson(jsonDecode(cloudJson));
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

  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    return PlayerInfo(
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
          ['Bird'],
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.parse(json['lastLoginDate'] as String)
          : null,
      rewardProgress: json['rewardProgress'] as int? ?? 0,
      playerId: json['playerId'] as String?,
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
      'lastLoginDate': _lastLoginDate?.toIso8601String(),
      'rewardProgress': _rewardProgress,
      'playerId': _playerId,
    };
  }

  // Debug/Legacy copyWith if needed
  PlayerInfo copyWith({
    int? highScore,
    int? coins,
    String? selectedTrail,
    List<String>? purchasedTrails,
    List<String>? purchasedSkins,
    int? lastModified,
    int? shields,
    int? luckyDay,
    Skins? selectedSkin,
    DateTime? lastLoginDate,
    int? rewardProgress,
  }) {
    return PlayerInfo(
      highScore: highScore ?? _highScore,
      coins: coins ?? _coins,
      shields: shields ?? _shields,
      luckyDay: luckyDay ?? _luckyDay,
      selectedTrail: selectedTrail ?? _selectedTrail,
      selectedSkin: selectedSkin ?? _selectedSkin,
      purchasedTrails: purchasedTrails ?? _purchasedTrails,
      purchasedSkins: purchasedSkins ?? _purchasedSkins,
      lastModified: lastModified ?? _lastModified,
      lastLoginDate: lastLoginDate ?? _lastLoginDate,
      rewardProgress: rewardProgress ?? _rewardProgress,
      playerId: playerId ?? _playerId,
    );
  }
}
