// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Flying Bird';

  @override
  String get startGame => 'Iniciar juego';

  @override
  String get continueGame => 'Continuar';

  @override
  String get watchAdToContinue => 'Ver un anuncio para continuar';

  @override
  String score(int score) {
    return 'Puntuación: $score';
  }

  @override
  String highScore(int score) {
    return 'Puntuación más alta: $score';
  }

  @override
  String bestScore(int score) {
    return 'Mejor: $score';
  }

  @override
  String get shop => 'Tienda';

  @override
  String get missions => 'Misiones';

  @override
  String get daily => 'Diario';

  @override
  String get weeklyOther => 'Semanal / Otros';

  @override
  String get resetsEveryDay => '¡Se reinicia cada día!';

  @override
  String get dailyRewards => 'Recompensas diarias';

  @override
  String get dailyProgress => 'Progreso diario';

  @override
  String get weeklyRewardClaimed => '¡Recompensa semanal reclamada!';

  @override
  String get trails => 'Estelas';

  @override
  String get powerUps => 'Poderes';

  @override
  String get birds => 'Aves';

  @override
  String get claim => 'Reclamar';

  @override
  String get claimed => 'Reclamado';

  @override
  String get completed => 'Completado';

  @override
  String get equip => 'Equipar';

  @override
  String get equipped => 'EQUIPADO';

  @override
  String get temp => 'TEMP';

  @override
  String get buy => 'Comprar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirmPurchase => 'Confirmar compra';

  @override
  String get luckyDay => 'Día de suerte';

  @override
  String get shield => 'Escudo';

  @override
  String get awesome => '¡Genial!';

  @override
  String get gotIt => '¡Entendido!';

  @override
  String owned(int count) {
    return 'Tienes: $count';
  }

  @override
  String get notificationTitle => '¡Te extrañamos! 🐦';

  @override
  String get notificationBody => '¡Vuelve a Flying Bird y supera tu récord! 🏆';

  @override
  String get tryLabel => 'Probar';

  @override
  String get open => 'Abrir';

  @override
  String get findOne => '¡Encuentra uno!';

  @override
  String get tracking => 'En curso';

  @override
  String get progress => 'Progreso';

  @override
  String get goToShop => 'Ir a la tienda';

  @override
  String get needSignIn => 'Debes iniciar sesión primero';

  @override
  String confirmBuyItem(String item, int price) {
    return '¿Deseas comprar $item por $price monedas?';
  }

  @override
  String boughtItem(String item) {
    return '¡Compraste $item!';
  }

  @override
  String needCoins(int price) {
    return '¡Necesitas $price monedas!';
  }

  @override
  String get skinEquippedOneLife => '¡Aspecto equipado por una vida!';

  @override
  String get trailEquippedOneLife => '¡Estela equipada por una vida!';

  @override
  String get loadingAd => 'Cargando anuncio...';

  @override
  String needScoreToUnlock(int score) {
    return '¡Necesitas $score puntos para desbloquear!';
  }

  @override
  String outOfPowerUpTitle(String powerUp) {
    return '¡Sin ${powerUp}s!';
  }

  @override
  String outOfPowerUpDesc(String powerUp) {
    return 'No te quedan ${powerUp}s para activar. ¿Te gustaría comprar más en la tienda?';
  }

  @override
  String get shieldDesc => 'Te protege de una colisión';

  @override
  String get luckyDayDesc => 'Aumenta la probabilidad de encontrar monedas';

  @override
  String get coinCollectorTitle => 'Recolector de monedas';

  @override
  String get coinCollectorDesc => 'Recoge 10 monedas en una partida';

  @override
  String get highFlyerTitle => 'Gran volador';

  @override
  String get highFlyerDesc => 'Alcanza una puntuación de 15';

  @override
  String get survivorTitle => 'Superviviente';

  @override
  String get survivorDesc => 'Juega 3 partidas';

  @override
  String get longTermTrackers => 'Seguimiento a largo plazo';

  @override
  String get dailyLoginTrackerTitle => 'Seguimiento de inicio diario';

  @override
  String get dailyLoginTrackerDesc =>
      'Días consecutivos iniciando sesión (reinicio semanal)';

  @override
  String get giftInventory => 'Inventario de regalos';

  @override
  String get giftInventoryDesc => '¡Abre regalos para obtener monedas al azar!';

  @override
  String get prizeShield => '¡1x Escudo!';

  @override
  String get prizeLuckyDay => '¡1x Día de suerte!';

  @override
  String prizeCoins(int coins) {
    return '¡$coins Monedas!';
  }

  @override
  String get dailyRewardDay7 =>
      '¡Felicidades!\n¡Llegaste al día 7 y ganaste 10 monedas!';

  @override
  String dailyRewardProgress(int progress) {
    return 'Día $progress de 7';
  }

  @override
  String dailyRewardComeBack(int nextDay) {
    return '¡Vuelve mañana para el día $nextDay!';
  }

  @override
  String leaderboardChallengeText(int score, String name) {
    return 'Necesitas $score puntos para superar a $name';
  }

  @override
  String get sound => 'Sonido';

  @override
  String get leaderboard => 'Clasificación';

  @override
  String get achievements => 'Logros';

  @override
  String get language => 'Idioma';

  @override
  String get skinBird => 'Pájaro';

  @override
  String get skinMagnet => 'Imán';

  @override
  String get skinGhost => 'Fantasma';

  @override
  String get skinBirdDesc => 'El pájaro clásico.';

  @override
  String get skinMagnetDesc => '¡Atrae monedas cercanas!';

  @override
  String get skinGhostDesc => '¡Puede atravesar tuberías!';

  @override
  String get trailNone => 'Ninguno';

  @override
  String get trailBubbles => 'Burbujas';

  @override
  String get trailLine => 'Línea';

  @override
  String get trailRects => 'Rectángulos';

  @override
  String get trailStars => 'Estrellas';

  @override
  String get trailLighting => 'Rayo';

  @override
  String get newRecordTitle => '¡NUEVO RÉCORD!';

  @override
  String get freeGiftEarned => '¡+1 REGALO GRATIS!';

  @override
  String get addedToGiftInventory => 'Añadido a tu inventario de regalos';

  @override
  String get collect => 'Recoger';

  @override
  String giftCollectedTotal(int count) {
    return '¡+1 Regalo recogido! Total: $count 🎁';
  }

  @override
  String get adLabel => 'Anuncio';

  @override
  String get rewardedAdUnavailable =>
      'El anuncio de recompensa no está disponible en este momento.';

  @override
  String get leaderboardTopPlayer =>
      '¡Eres el #1 en la clasificación! ¡Defiende tu récord! 👑';
}
