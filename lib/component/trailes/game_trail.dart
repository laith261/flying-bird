import 'package:flame/components.dart';

abstract interface class GameTrail {
  void addPoint(Vector2 point);
  bool get isPro;
  set isPro(bool value);
  double get opacity;
  set opacity(double value);
  void reset();
}
