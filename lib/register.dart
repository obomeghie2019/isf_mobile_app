import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:isf_app/screens/registration_form_screen.dart';

class MarathonRegistrationScreen extends StatefulWidget {
  const MarathonRegistrationScreen({super.key});

  @override
  State<MarathonRegistrationScreen> createState() =>
      _MarathonRegistrationScreenState();
}

class _MarathonRegistrationScreenState
    extends State<MarathonRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final String _verifyApiUrl =
      'https://360globalnetwork.com.ng/isf2025/mobile_verify_payment.php';
  final String _phpApiUrl =
      'https://360globalnetwork.com.ng/isf2025/mobile_init_payment.php';
  final String _fixedAmount = '2000';

  bool _isProcessingPayment = false;
  String? _paymentReference;

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessingPayment = true);

      try {
        String regNo =
            'ISF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

        final response = await http.post(
          Uri.parse(_phpApiUrl),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'uemail': _emailController.text.trim(),
            'amount': _fixedAmount,
            'uregno': regNo,
            'payer1': 'Marathon Participant',
            'uphone': '08000000000',
          },
        );

        if (response.statusCode != 200) {
          throw Exception('Server Error: ${response.statusCode}');
        }

        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final authorizationUrl = data['data']['authorization_url'];
          final reference = data['data']['reference'];
          _paymentReference = reference;

          // Open Paystack WebView
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaystackWebView(
                authorizationUrl: authorizationUrl,
                reference: reference,
                onSuccess: (ref) {
                  _verifyPaymentAndContinue(ref);
                },
                onCancel: () {
                  setState(() => _isProcessingPayment = false);
                  Get.snackbar(
                    "Payment Cancelled",
                    "You cancelled the payment",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                },
              ),
            ),
          );
        } else {
          throw Exception(data['message'] ?? 'Payment initialization failed');
        }
      } catch (e) {
        setState(() => _isProcessingPayment = false);
        Get.snackbar(
          "Payment Error",
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _verifyPaymentAndContinue([String? ref]) async {
    final referenceToVerify = ref ?? _paymentReference;

    if (referenceToVerify == null) {
      Get.snackbar(
        "Error",
        "Payment reference not found",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isProcessingPayment = true);

    try {
      final response = await http.get(
        Uri.parse('$_verifyApiUrl?reference=$referenceToVerify'),
      );

      final data = json.decode(response.body);

      if (data['status'] == true) {
        setState(() => _isProcessingPayment = false);

        // Navigate to registration form
        // After payment is verified
        Get.to(() => ContinueRegistrationScreen(
              name: _nameController.text,
              email: _emailController.text.trim(),
              amount: _fixedAmount,
              reference: referenceToVerify,
              phone: _phoneController.text,
              regNo:
                  'ISF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
            ));
      } else {
        setState(() => _isProcessingPayment = false);
        Get.snackbar(
          "Verification Failed",
          data['message'] ?? 'Payment verification failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() => _isProcessingPayment = false);
      Get.snackbar(
        "Verification Error",
        "Could not verify payment",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 6, 22),
      appBar: AppBar(
        title: const Text(
          'ISF Marathon Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 59, 59, 223),
        foregroundColor: const Color.fromARGB(255, 249, 247, 247),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Pay ₦$_fixedAmount to Register for ISF Marathon',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email,
                        color: Color.fromARGB(255, 59, 59, 223)),
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 16),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Amount Display
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount to Pay:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₦$_fixedAmount',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Payment Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 59, 59, 223),
                          Color.fromARGB(255, 4, 59, 6)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: _isProcessingPayment ? null : _processPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // needed for gradient
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isProcessingPayment
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 59, 59, 223),
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.payment, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'PAY NOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

// 🔒 Paystack Secure Payment Assurance (AFTER Pay Button)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blueGrey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            color: Colors.green,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guaranteed Secure Payment',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Payments are securely processed by Paystack. '
                                  'We do not store your card or bank details.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Paystack branding + methods
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/paystacklogo.png',
                            height: 22,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Secured by Paystack',
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.credit_card, size: 22),
                          SizedBox(width: 14),
                          Icon(Icons.account_balance, size: 22),
                          SizedBox(width: 14),
                          Icon(Icons.phone_android, size: 22),
                        ],
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Cards • Bank Transfer • USSD',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  'All transactions are encrypted and PCI-DSS compliant.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: Color.fromARGB(255, 10, 117, 56)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// PaystackWebView widget implementation
class PaystackWebView extends StatefulWidget {
  final String authorizationUrl;
  final String reference;
  final Function(String reference) onSuccess;
  final VoidCallback onCancel;

  const PaystackWebView({
    super.key,
    required this.authorizationUrl,
    required this.reference,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  State<PaystackWebView> createState() => _PaystackWebViewState();
}

class _PaystackWebViewState extends State<PaystackWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Listen for Paystack redirect URLs
            if (request.url.contains('paystack.co/close') ||
                request.url.contains('close')) {
              widget.onCancel();
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            if (request.url.contains('reference=${widget.reference}') ||
                request.url.contains(widget.reference)) {
              widget.onSuccess(widget.reference);
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authorizationUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new_outlined),
        title: const Text('Pay with Paystack'),
        backgroundColor: const Color.fromARGB(255, 59, 59, 223),
        foregroundColor: Colors.white,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
