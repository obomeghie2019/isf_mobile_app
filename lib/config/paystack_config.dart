// lib/config/paystack_config.dart
class PaystackConfig {
  // Test public key (replace with your actual key)
  static const String testPublicKey =
      'pk_test_7501330e97e19790fc688f67cba303fb2858c5c2';

  // Live public key (for production)
  static const String livePublicKey = 'pk_live_your_live_public_key_here';

  // Use test mode during development
  static bool isTestMode = true;

  static String get publicKey => isTestMode ? testPublicKey : livePublicKey;

  // Currency
  static const String currency = 'NGN';

  // Fixed amount for marathon registration
  static const int marathonRegistrationAmount = 200000; // in kobo (₦2,000)
}
