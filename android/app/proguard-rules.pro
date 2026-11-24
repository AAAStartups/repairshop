# QuickFix ProGuard & R8 Optimization Rules for Release Builds

# Flutter Engine
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Preserve Riverpod & State Management
-keepattributes *Annotation*
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Preserve Geolocation & Platform Channels
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.geocoding.** { *; }

# Preserve Network & JSON Serialization
-keepattributes Signature
-keepattributes Exceptions
-dontwarn javax.annotation.**
-dontwarn okio.**
