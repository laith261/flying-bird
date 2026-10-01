# Flutter Wrapper & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Preserve native JNI methods (critical for flutter_soloud audio and Flutter engine)
-keepclasseswithmembernames class * {
    native <methods>;
}

# Flutter SoLoud (Audio Engine)
-keep class net.soloud.** { *; }
-keep class * implements net.soloud.** { *; }

# Google Mobile Ads (AdMob)
-keep public class com.google.android.gms.ads.** {
   public *;
}
-keep public class com.google.ads.** {
   public *;
}
-keep class com.google.android.gms.ads.identifier.** { *; }
-dontwarn com.google.android.gms.ads.**

# Google Play Games Services
-keep class com.google.android.gms.games.** { *; }
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.games.**

# Google Play In-App Updates and Reviews
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.review.** { *; }
-keep class com.google.android.play.core.common.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**

# Firebase (Core, Analytics, Messaging)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Flutter Secure Storage & AndroidX Security
-keep class androidx.security.crypto.** { *; }
-dontwarn androidx.security.crypto.**

# SharedPreferences & Vibration
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.benjaminabel.vibration.** { *; }

# Unity Ads SDK & Mediation Adapter
-keep class com.unity3d.ads.** { *; }
-keep interface com.unity3d.ads.** { *; }
-keep class com.unity3d.services.** { *; }
-keep interface com.unity3d.services.** { *; }
-dontwarn com.unity3d.ads.**
-dontwarn com.unity3d.services.**

-keep class com.google.ads.mediation.unity.** { *; }
-dontwarn com.google.ads.mediation.unity.**

# General Java / Kotlin Attributes for Reflection and Serialization
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes EnclosingMethod

