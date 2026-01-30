import 'package:flutter_dotenv/flutter_dotenv.dart';

class Consts {
  static const gravity = 8.0;
  static const jump = -4.5;
  static const gap = 85;
  static const pipeSpeed = 150.0;
  static const pipeAddAt = 150.0;
  static const pipeMoveSpeed = 75;
  static String leaderBoard = dotenv.env['leaderBoard']!;
  static String achievements50 = dotenv.env['achievements50']!;
  // static String achievements1000 = dotenv.env['achievements1000']!;
  // static String achievements5000 = dotenv.env['achievements5000']!;
  // static String achievements10000 = dotenv.env['achievements10000']!;
  static String savedDataName = 'PlayerData';
}
