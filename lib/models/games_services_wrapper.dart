import 'package:games_services/games_services.dart';

class GamesServicesWrapper {
  const GamesServicesWrapper();

  Future<String?> getPlayerID() async {
    return GamesServices.getPlayerID();
  }

  Future<String?> loadGame({required String name}) async {
    return GamesServices.loadGame(name: name);
  }

  Future<String?> saveGame({required String name, required String data}) async {
    return GamesServices.saveGame(name: name, data: data);
  }
}
