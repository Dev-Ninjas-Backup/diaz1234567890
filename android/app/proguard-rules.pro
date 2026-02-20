# Flutter Stripe SDK - Keep push provisioning classes
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivity { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivity$g { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivityStarter { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error { *; }
-keep class com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider { *; }
-keep class com.stripe.android.pushProvisioning.EphemeralKeyUpdateListener { *; }

# Suppress warnings about missing push provisioning classes (not available in all library versions)
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.pushprovisioning.**

# Keep Stripe SDK classes
-keep class com.stripe.** { *; }
-keep interface com.stripe.** { *; }
-keep class com.google.android.material.** { *; }

# Keep React Native Stripe SDK classes
-keep class com.reactnativestripesdk.** { *; }
-keep interface com.reactnativestripesdk.** { *; }

# Keep card form classes
-keep class com.stripe.android.view.CardFormView { *; }
-keep class com.stripe.android.view.CardWidgetProgressView { *; }
-keep class com.stripe.android.view.CardNumberEditText { *; }
