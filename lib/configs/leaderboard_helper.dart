import 'package:games_services/games_services.dart' as gs;
import '../models/player_data.dart';
import 'const.dart';
import 'functions.dart';

class ChallengeData {
  final String targetName;
  final int pointsNeeded;
  final int targetScore;

  ChallengeData({
    required this.targetName,
    required this.pointsNeeded,
    required this.targetScore,
  });
}

class LeaderboardHelper {
  static Future<void> syncHighScore(PlayerInfo playerData) async {
    try {
      if (await gs.GameAuth.isSignedIn == false) {
        bool signedIn = await Functions.singIn();
        if (!signedIn) return;
      }

      // Get current player score from leaderboard
      final leaderboardScore = await gs.Leaderboards.getPlayerScoreObject(
        androidLeaderboardID: Consts.leaderBoard,
        iOSLeaderboardID: Consts.leaderBoard,
        scope: gs.PlayerScope.global,
        timeScope: gs.TimeScope.allTime,
      );

      if (leaderboardScore != null) {
        int cloudScore = leaderboardScore.rawScore;
        int localScore = playerData.highScore;

        if (localScore > cloudScore) {
          // Sync Local to Leaderboard
          await gs.Leaderboards.submitScore(
            score: gs.Score(
              androidLeaderboardID: Consts.leaderBoard,
              iOSLeaderboardID: Consts.leaderBoard,
              value: localScore,
            ),
          );
        } else if (cloudScore > localScore) {
          // Sync Leaderboard to Local
          await playerData.runBatched([() => playerData.updateHighScore(cloudScore)]);
        }
      }
    } catch (e) {
      // ignore
    }
  }

  static Future<ChallengeData?> fetchChallengeData(int currentHighScore) async {
    try {
      if (await gs.GameAuth.isSignedIn == false) {
        bool signedIn = await Functions.singIn();
        if (!signedIn) return null;
      }

      // Load scores around the player
      // We can use playerCentered: true to get scores around the current player
      final scores = await gs.Leaderboards.loadLeaderboardScores(
        androidLeaderboardID: Consts.leaderBoard,
        iOSLeaderboardID: Consts.leaderBoard,
        playerCentered: true,
        scope: gs.PlayerScope.global,
        timeScope: gs.TimeScope.allTime,
        maxResults: 30,
      );

      if (scores == null || scores.isEmpty) return null;

      gs.LeaderboardScoreData? targetScore;
      int? playerRank;

      // Find current player's rank from scores
      for (var score in scores) {
        if (score.rawScore <= currentHighScore) {
          playerRank = score.rank;
          break;
        }
      }

      if (playerRank != null && playerRank > 1) {
        // Target is the person at playerRank - 1
        try {
          targetScore = scores.firstWhere(
            (e) => e.rank == playerRank! - 1,
            orElse: () => scores.first,
          );
        } catch (_) {
          targetScore = scores.first;
        }
      } else if (playerRank == 1) {
        // Player is #1!
        return null;
      } else {
        // Player not found or rank not clear, fallback to targeting the highest person in this list
        targetScore = scores.first;
      }

      if (targetScore.rawScore > currentHighScore) {
        return ChallengeData(
          targetName: targetScore.scoreHolder.displayName,
          pointsNeeded: targetScore.rawScore - currentHighScore,
          targetScore: targetScore.rawScore,
        );
      }

      return null;
    } catch (e) {
      // ignore
      return null;
    }
  }
}
