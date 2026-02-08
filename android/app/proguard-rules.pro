# Stripe SDK ProGuard Rules - Keep all Stripe classes
-keep class com.stripe.android.** { *; }
-keep class com.stripe.** { *; }
-keep interface com.stripe.** { *; }
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep interface com.stripe.android.pushProvisioning.** { *; }

# React Native Stripe SDK
-keep class com.reactnativestripesdk.** { *; }
-keep interface com.reactnativestripesdk.** { *; }
-keep class com.reactnativestripesdk.pushprovisioning.** { *; }
-keep interface com.reactnativestripesdk.pushprovisioning.** { *; }

# Keep all inner classes and enums from Stripe
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$** { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivity$** { *; }
-keep interface com.stripe.android.pushProvisioning.EphemeralKeyUpdateListener { *; }
-keep interface com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider { *; }

# Don't warn about Stripe SDK issues
-dontwarn com.stripe.**
-dontwarn com.reactnativestripesdk.**

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Remove logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
