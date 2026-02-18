// ignore_for_file: avoid_print

import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  // Live Stripe Public Key
  static const String livePublicKey =
      //'pk_live_51SkFIS45xKlHxaXnHw8Zs3fX38b1MOlUTyMbGSlTt630eKwA7Z5hUy7J8Bx0RZyiznA6KGDsqQAHQKwbrZY6kU8H00hJuSnyzp';
      'pk_test_51RlFNRQNJ9V9C9o5Rz8lIUhKRJ7foy4WRfQR4z05Oy41puNBooAmZE0KuBy2K55iGVHrioX1CY3KotwYxwIyxHR800J4o3qINh';

  /// Initialize Stripe with the live public key
  static Future<void> initialize() async {
    try {
      print('\n═══════════════════════════════════════════════════════');
      print('🔵 INITIALIZING STRIPE');
      print('═══════════════════════════════════════════════════════');
      print('Public Key: $livePublicKey');

      Stripe.publishableKey = livePublicKey;

      print('✅ Stripe initialized successfully');
      print('═══════════════════════════════════════════════════════\n');
    } catch (e) {
      print('❌ Error initializing Stripe: $e\n');
      rethrow;
    }
  }

  /// Confirm a setup intent with Stripe using CardField data
  /// Let Stripe handle payment method creation and confirmation internally
  static Future<bool> confirmSetupIntent({
    required String clientSecret,
    required CardFieldInputDetails cardFieldDetails,
  }) async {
    try {
      print('\n═══════════════════════════════════════════════════════');
      print('💳 CONFIRMING SETUP INTENT WITH STRIPE');
      print('═══════════════════════════════════════════════════════');
      print('Setup Intent Client Secret: $clientSecret');
      print('Card Complete: ${cardFieldDetails.complete}');
      print('═══════════════════════════════════════════════════════\n');

      // Validate card details
      if (!cardFieldDetails.complete) {
        throw Exception(
          'Card details are incomplete. Please fill in all required fields.',
        );
      }

      print('✅ Card validation passed\n');
      print('Confirming setup intent with Stripe...');

      // Stripe handles PaymentMethod creation internally
      final setupIntent = await Stripe.instance.confirmSetupIntent(
        paymentIntentClientSecret: clientSecret,
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(email: 'customer@example.com'),
          ),
        ),
      );

      print('═══════════════════════════════════════════════════════');
      print('✅ SETUP INTENT CONFIRMED SUCCESSFULLY WITH STRIPE');
      print('═══════════════════════════════════════════════════════');
      print('Setup Intent Status: ${setupIntent.status}');
      print('Payment Method ID: ${setupIntent.paymentMethodId}');
      print('═══════════════════════════════════════════════════════\n');

      // Check if setup intent was successful (case-insensitive)
      final status = setupIntent.status.toLowerCase();
      return status == 'succeeded';
    } on StripeException catch (e) {
      print('\n❌ STRIPE ERROR:');
      print('Error Code: ${e.error.code}');
      print('Error Message: ${e.error.message}');
      print('Setup Intent ClientSecret used: $clientSecret');
      print('═══════════════════════════════════════════════════════\n');

      // Check if it's a setup intent not found error
      if (e.error.message?.contains('No such setupintent') == true) {
        print('⚠️ Setup intent does not exist on Stripe.');
        print('⚠️ Possible causes:');
        print('   1. Stripe API keys mismatch (test vs live)');
        print('   2. Setup intent was created but expired');
        print('   3. Setup intent was created on a different Stripe account');
        print('═══════════════════════════════════════════════════════\n');
      }

      throw Exception(
        'Stripe error: ${e.error.message ?? "Unknown error occurred"}',
      );
    } catch (e) {
      print('\n❌ Error confirming setup intent with Stripe: $e\n');
      throw Exception('Error confirming setup intent with Stripe: $e');
    }
  }

  /// Validate card number using basic format validation
  /// Note: Stripe will perform full validation on the backend
  /// This just ensures the card number is numeric and correct length
  static bool validateCardNumber(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'\s+'), '');

    print('[DEBUG] Validating card number: $cardNumber');
    print('[DEBUG] Cleaned card number: $digits');
    print('[DEBUG] Card length: ${digits.length}');

    // Check if it's all digits
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      print('[DEBUG] Card contains non-digit characters');
      return false;
    }

    // Standard credit card numbers are 13-19 digits
    if (digits.length < 13 || digits.length > 19) {
      print('[DEBUG] Card length is invalid (must be 13-19 digits)');
      return false;
    }

    // Optional: Validate Luhn checksum (can be bypassed for test cards)
    // This is a basic implementation that works for most real cards and some test cards
    if (_luhnCheck(digits)) {
      print('[DEBUG] ✓ Card passed Luhn validation');
      return true;
    } else {
      // For Stripe, we allow cards that don't pass Luhn since test cards may vary
      // The actual validation will happen on Stripe's backend
      print(
        '[DEBUG] ⚠ Card did not pass Luhn check, but allowing for Stripe processing',
      );
      return true; // Allow it - let Stripe validate on backend
    }
  }

  /// Luhn algorithm implementation
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool isEven = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }

  /// Validate expiry date (MM/YY format)
  static bool validateExpiryDate(String expiryDate) {
    final parts = expiryDate.split('/');
    if (parts.length != 2) return false;

    try {
      final month = int.parse(parts[0]);
      final year = int.parse(parts[1]);

      if (month < 1 || month > 12) {
        print('[DEBUG] Invalid month: $month (must be 1-12)');
        return false;
      }

      // Accept YY format (26 = 2026) or YYYY format (2026 = 2026)
      int fullYear = year;
      if (year < 100) {
        fullYear = year + 2000;
      }

      print('[DEBUG] Validating expiry: $month/$year ($fullYear)');

      // Check if card is expired
      final now = DateTime.now();
      // Set expiry to last day of the month
      final expiryDateTime = DateTime(fullYear, month + 1, 0);

      if (expiryDateTime.isBefore(now)) {
        print('[DEBUG] Card is expired (expiry: $expiryDateTime, now: $now)');
        return false;
      }

      print('[DEBUG] ✓ Expiry date is valid');
      return true;
    } catch (e) {
      print('[DEBUG] Error validating expiry: $e');
      return false;
    }
  }

  /// Validate CVC (3-4 digits)
  static bool validateCvc(String cvc) {
    return RegExp(r'^\d{3,4}$').hasMatch(cvc);
  }

  /// Extract month and year from MM/YY format
  static Map<String, String> parseExpiryDate(String expiryDate) {
    final parts = expiryDate.split('/');
    if (parts.length != 2) {
      throw Exception('Invalid expiry date format. Use MM/YY');
    }

    return {'month': parts[0], 'year': parts[1]};
  }

  /// Clean card number (remove spaces)
  static String cleanCardNumber(String cardNumber) {
    return cardNumber.replaceAll(RegExp(r'\s+'), '');
  }

  /// Format card number with spaces (e.g., 4242 4242 4242 4242)
  static String formatCardNumber(String cardNumber) {
    final cleaned = cleanCardNumber(cardNumber);
    return cleaned
        .replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ')
        .trim();
  }
}
