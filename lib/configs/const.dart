import 'package:flutter_dotenv/flutter_dotenv.dart';

class Consts {
  static const gravity = 8.0;
  static const jump = -4.5;
  static const gap = 85;
  static const pipeSpeed = 150.0;
  static const pipeAddAt = 150.0;
  static const pipeMoveSpeed = 75;
  static String leaderBoard = dotenv.env['leaderBoard']!;
}
