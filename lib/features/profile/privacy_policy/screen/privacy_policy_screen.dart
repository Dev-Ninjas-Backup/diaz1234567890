import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Privacy Policy'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data We Collect',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "When you use our app, we only collect the details needed to make your journey smooth. This includes your basic profile information, your EV details so we can track charging status, your location to guide you to nearby stations, and payment details to ensure secure transactions. Nothing extra, just the essentials to keep your charging experience easy and safe.",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'How We Use It:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "We use your information only to make your charging experience smarter and safer. Your profile helps us recognize you, your vehicle details let us show real-time battery and charging updates, and your location guides you to the nearest station. Payment info is used only to process transactions securely. Everything we do with your data is focused on giving you a smooth, reliable, and worry-free ride.",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Safety',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Your safety is our first priority. That’s why every piece of information you share is protected with strong encryption and stored on secure servers. We never sell or share your personal details without your permission. Our goal is simple  to keep your data safe so you can charge and drive with complete peace of mind.",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Rights:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "You are always in control of your information. You can update your profile details, change your preferences, or delete your account whenever you choose. If you want to see what data we hold about you, just let us know and we’ll share it. Your data belongs to you, and you have the final say in how it’s used.",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
