import 'package:flutter/widgets.dart';
import '../component/skins/skin_enum.dart';
import '../component/trailes/trail_enum.dart';
import '../component/power_ups/power_up_enum.dart';
import 'app_localizations.dart';
import 'language_manager.dart';

export 'app_localizations.dart';
export 'language_manager.dart';

/// Extension on [AppLocalizations] to provide text direction metadata safely.
extension LocalizedAppLocalizations on AppLocalizations {
  TextDirection get textDirection =>
      LanguageManager.directionOf(Locale(localeName));
  bool get isRtl => textDirection == TextDirection.rtl;
}

/// Extension on [BuildContext] to provide convenient access to [AppLocalizations] and direction.
extension LocalizedBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  TextDirection get textDirection => l10n.textDirection;
  bool get isRtl => l10n.isRtl;
}

/// Extension on [Skins] to provide localized names and descriptions.
extension LocalizedSkins on Skins {
  String localizedName(BuildContext context) {
    switch (this) {
      case Skins.bird:
        return context.l10n.skinBird;
      case Skins.magnet:
        return context.l10n.skinMagnet;
      case Skins.ghost:
        return context.l10n.skinGhost;
    }
  }

  String localizedDescription(BuildContext context) {
    switch (this) {
      case Skins.bird:
        return context.l10n.skinBirdDesc;
      case Skins.magnet:
        return context.l10n.skinMagnetDesc;
      case Skins.ghost:
        return context.l10n.skinGhostDesc;
    }
  }
}

/// Extension on [Trails] to provide localized names.
extension LocalizedTrails on Trails {
  String localizedName(BuildContext context) {
    switch (this) {
      case Trails.none:
        return context.l10n.trailNone;
      case Trails.circle:
        return context.l10n.trailBubbles;
      case Trails.line:
        return context.l10n.trailLine;
      case Trails.rect:
        return context.l10n.trailRects;
      case Trails.star:
        return context.l10n.trailStars;
      case Trails.lightning:
        return context.l10n.trailLighting;
    }
  }
}

/// Extension on [PowerUps] to provide localized names and descriptions.
extension LocalizedPowerUps on PowerUps {
  String localizedName(BuildContext context) {
    switch (this) {
      case PowerUps.shield:
        return context.l10n.shield;
      case PowerUps.luckyDay:
        return context.l10n.luckyDay;
    }
  }

  String localizedDescription(BuildContext context) {
    switch (this) {
      case PowerUps.shield:
        return context.l10n.shieldDesc;
      case PowerUps.luckyDay:
        return context.l10n.luckyDayDesc;
    }
  }
}

