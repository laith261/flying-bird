import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/player_data.dart';

class DailyMissionsManager extends ChangeNotifier {
  static final DailyMissionsManager instance = DailyMissionsManager._internal();

  DailyMissionsManager._internal();

  SharedPreferences? _prefs;
  bool _isInitialized = false;

  String _date = '';
  int _coinsProgress = 0;
  int _scoreProgress = 0;
  int _gamesPlayed = 0;
  bool _coinsClaimed = false;
  bool _scoreClaimed = false;
  bool _gamesClaimed = false;

  // Getters
  String get date => _date;
  int get coinsProgress => _coinsProgress;
  int get scoreProgress => _scoreProgress;
  int get gamesPlayed => _gamesPlayed;
  bool get coinsClaimed => _coinsClaimed;
  bool get scoreClaimed => _scoreClaimed;
  bool get gamesClaimed => _gamesClaimed;

  bool get hasUnclaimedCompletedMission {
    _checkReset();
    bool coinsCompleted = _coinsProgress >= 10 && !_coinsClaimed;
    bool scoreCompleted = _scoreProgress >= 15 && !_scoreClaimed;
    bool gamesCompleted = _gamesPlayed >= 3 && !_gamesClaimed;
    return coinsCompleted || scoreCompleted || gamesCompleted;
  }

  Future<void> init() async {
    if (_isInitialized) {
      _checkReset();
      return;
    }
    _prefs = await SharedPreferences.getInstance();
    _loadData();
    _isInitialized = true;
    notifyListeners();
  }

  void _loadData() {
    if (_prefs == null) return;
    _date = _prefs!.getString('dm_date') ?? '';
    _coinsProgress = _prefs!.getInt('dm_coins') ?? 0;
    _scoreProgress = _prefs!.getInt('dm_score') ?? 0;
    _gamesPlayed = _prefs!.getInt('dm_games') ?? 0;
    _coinsClaimed = _prefs!.getBool('dm_coins_claimed') ?? false;
    _scoreClaimed = _prefs!.getBool('dm_score_claimed') ?? false;
    _gamesClaimed = _prefs!.getBool('dm_games_claimed') ?? false;

    _checkReset();
  }

  void _checkReset() {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    if (_date != todayStr) {
      _date = todayStr;
      _coinsProgress = 0;
      _scoreProgress = 0;
      _gamesPlayed = 0;
      _coinsClaimed = false;
      _scoreClaimed = false;
      _gamesClaimed = false;
      _saveData();
      notifyListeners();
    }
  }

  Future<void> _saveData() async {
    if (_prefs == null) return;
    await _prefs!.setString('dm_date', _date);
    await _prefs!.setInt('dm_coins', _coinsProgress);
    await _prefs!.setInt('dm_score', _scoreProgress);
    await _prefs!.setInt('dm_games', _gamesPlayed);
    await _prefs!.setBool('dm_coins_claimed', _coinsClaimed);
    await _prefs!.setBool('dm_score_claimed', _scoreClaimed);
    await _prefs!.setBool('dm_games_claimed', _gamesClaimed);
  }

  // Tracking methods
  Future<void> trackCoinCollected(int amount) async {
    await init();
    _checkReset();
    if (_coinsProgress < 10) {
      _coinsProgress = (_coinsProgress + amount).clamp(0, 10);
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> trackGamePlayed(int score) async {
    await init();
    _checkReset();
    if (_gamesPlayed < 3) {
      _gamesPlayed++;
    }
    if (score > _scoreProgress) {
      _scoreProgress = score.clamp(0, 15);
    }
    await _saveData();
    notifyListeners();
  }

  // Claim methods
  Future<void> claimCoinsReward(PlayerInfo playerData) async {
    await init();
    _checkReset();
    if (!_coinsClaimed && _coinsProgress >= 10) {
      _coinsClaimed = true;
      notifyListeners();
      await _saveData();
      await playerData.runBatched([() => playerData.addCoins(10)]);
    }
  }

  Future<void> claimScoreReward(PlayerInfo playerData) async {
    await init();
    _checkReset();
    if (!_scoreClaimed && _scoreProgress >= 15) {
      _scoreClaimed = true;
      notifyListeners();
      await _saveData();
      await playerData.runBatched([() => playerData.addCoins(15)]);
    }
  }

  Future<void> claimGamesReward(PlayerInfo playerData) async {
    await init();
    _checkReset();
    if (!_gamesClaimed && _gamesPlayed >= 3) {
      _gamesClaimed = true;
      notifyListeners();
      await _saveData();
      await playerData.runBatched([() => playerData.addCoins(10)]);
    }
  }

  @visibleForTesting
  void resetForTesting() {
    _isInitialized = false;
    _date = '';
    _coinsProgress = 0;
    _scoreProgress = 0;
    _gamesPlayed = 0;
    _coinsClaimed = false;
    _scoreClaimed = false;
    _gamesClaimed = false;
  }
}
