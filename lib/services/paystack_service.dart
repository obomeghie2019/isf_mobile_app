import 'dart:convert';
import 'package:http/http.dart' as http;

// Model classes
class PaystackInitializeResponse {
  final bool status;
  final String message;
  final PaystackData? data;

  PaystackInitializeResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaystackInitializeResponse.fromJson(Map<String, dynamic> json) {
    return PaystackInitializeResponse(
      status: json['status'] == true || json['status'] == 'true',
      message: json['message'] ?? '',
      data: json['data'] != null ? PaystackData.fromJson(json['data']) : null,
    );
  }
}

class PaystackData {
  final String authorizationUrl;
  final String accessCode;
  final String reference;

  PaystackData({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  factory PaystackData.fromJson(Map<String, dynamic> json) {
    return PaystackData(
      authorizationUrl: json['authorization_url'] ?? '',
      accessCode: json['access_code'] ?? '',
      reference: json['reference'] ?? '',
    );
  }
}

class PaystackVerifyResponse {
  final bool status;
  final String message;
  final VerifyData? data;

  PaystackVerifyResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaystackVerifyResponse.fromJson(Map<String, dynamic> json) {
    return PaystackVerifyResponse(
      status: json['status'] == true || json['status'] == 'true',
      message: json['message'] ?? '',
      data: json['data'] != null ? VerifyData.fromJson(json['data']) : null,
    );
  }
}

class VerifyData {
  final String id;
  final String status;
  final String reference;
  final String gatewayResponse;
  final String paidAt;
  final String channel;
  final String ipAddress;
  final Metadata metadata;
  final Authorization authorization;

  VerifyData({
    required this.id,
    required this.status,
    required this.reference,
    required this.gatewayResponse,
    required this.paidAt,
    required this.channel,
    required this.ipAddress,
    required this.metadata,
    required this.authorization,
  });

  factory VerifyData.fromJson(Map<String, dynamic> json) {
    return VerifyData(
      id: json['id']?.toString() ?? '',
      status: json['status'] ?? '',
      reference: json['reference'] ?? '',
      gatewayResponse: json['gateway_response'] ?? '',
      paidAt: json['paid_at'] ?? '',
      channel: json['channel'] ?? '',
      ipAddress: json['ip_address'] ?? '',
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
      authorization: Authorization.fromJson(json['authorization'] ?? {}),
    );
  }
}

class Metadata {
  final String payer;
  final String phone;
  final String email;
  final String regno;
  final String actualamt;

  Metadata({
    required this.payer,
    required this.phone,
    required this.email,
    required this.regno,
    required this.actualamt,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      payer: json['payer'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      regno: json['regno'] ?? '',
      actualamt: json['actualamt']?.toString() ?? json['amt']?.toString() ?? '',
    );
  }
}

class Authorization {
  final String cardType;
  final String bank;
  final String last4;
  final String expMonth;
  final String expYear;
  final String id;

  Authorization({
    required this.cardType,
    required this.bank,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.id,
  });

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(
      cardType: json['card_type'] ?? '',
      bank: json['bank'] ?? '',
      last4: json['last4']?.toString() ?? '',
      expMonth: json['exp_month']?.toString() ?? '',
      expYear: json['exp_year']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
    );
  }
}

// Service class
class PaystackService {
  // Replace with your PHP API endpoint
  static const String baseUrl = 'https://360globalnetwork.com.ng/isf2025/api';

  // Initialize payment endpoint
  static const String initializePaymentUrl = '$baseUrl/initialize_payment.php';

  // Verify payment endpoint
  static const String verifyPaymentUrl = '$baseUrl/verify_payment.php';

  // Save payment endpoint
  static const String savePaymentUrl = '$baseUrl/save_payment.php';

  // Initialize payment
  static Future<PaystackInitializeResponse> initializePayment({
    required String email,
    required String amount,
    required String regno,
    required String payer,
    required String phone,
  }) async {
    try {
      print('Initializing payment for: $email, Amount: $amount');

      final response = await http.post(
        Uri.parse(initializePaymentUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'uemail': email,
          'amount': amount,
          'uregno': regno,
          'payer1': payer,
          'uphone': phone,
          'btnPay': 'true',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PaystackInitializeResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to initialize payment. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in initializePayment: $e');
      throw Exception('Error initializing payment: $e');
    }
  }

  // Verify payment
  static Future<PaystackVerifyResponse> verifyPayment({
    required String trxref,
    required String reference,
  }) async {
    try {
      print('Verifying payment reference: $reference');

      final response = await http.get(
        Uri.parse('$verifyPaymentUrl?reference=$reference'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Verify response status: ${response.statusCode}');
      print('Verify response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PaystackVerifyResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to verify payment. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in verifyPayment: $e');
      throw Exception('Error verifying payment: $e');
    }
  }

  // Save payment to database
  static Future<bool> savePaymentToDatabase({
    required VerifyData paymentData,
  }) async {
    try {
      print('Saving payment to database: ${paymentData.reference}');

      final response = await http.post(
        Uri.parse(savePaymentUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'payer_names': paymentData.metadata.payer,
          'regno': paymentData.metadata.regno,
          'email': paymentData.metadata.email,
          'phone': paymentData.metadata.phone,
          'amount_paid': paymentData.metadata.actualamt,
          'payment_ref': paymentData.reference,
          'trax_id': paymentData.id,
          'payment_status': '1',
          'gatewayRes': paymentData.gatewayResponse,
          'payment_date': paymentData.paidAt,
          'channel': paymentData.channel,
          'ip_address': paymentData.ipAddress,
          'card_type': paymentData.authorization.cardType,
          'bank': paymentData.authorization.bank,
          'card_lastfour': paymentData.authorization.last4,
          'card_exp_month': paymentData.authorization.expMonth,
          'card_exp_year': paymentData.authorization.expYear,
        }),
      );

      print('Save payment response: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error saving payment: $e');
      return false;
    }
  }
}
