// lib/models/paystack_response.dart
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
      actualamt: json['actualamt']?.toString() ?? '',
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
