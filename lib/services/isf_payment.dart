import 'dart:math';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaystackPaymentScreen extends StatefulWidget {
  const PaystackPaymentScreen({super.key});

  @override
  State<PaystackPaymentScreen> createState() => _PaystackPaymentScreenState();
}

class _PaystackPaymentScreenState extends State<PaystackPaymentScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> _startPayment() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    final reference = 'ISF-${Random().nextInt(1000000)}';

    final response = await http.post(
      Uri.parse('https://360globalnetwork.com.ng/api/initialize_payment.php'),
      body: {
        'email': email,
        'amount': (2000 * 100).toString(),
        'reference': reference,
      },
    );

    final result = jsonDecode(response.body);

    if (result['status'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaystackWebView(
            url: result['authorization_url'],
            reference: reference,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paystack Payment')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _startPayment,
                child: const Text('PAY ₦2,000'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaystackWebView extends StatefulWidget {
  final String url;
  final String reference;

  const PaystackWebView({
    super.key,
    required this.url,
    required this.reference,
  });

  @override
  State<PaystackWebView> createState() => _PaystackWebViewState();
}

class _PaystackWebViewState extends State<PaystackWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains('success')) {
              _verifyPayment();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _verifyPayment() async {
    final response = await http.post(
      Uri.parse('https://360globalnetwork.com.ng/api/verify_payment.php'),
      body: {'reference': widget.reference},
    );

    final result = jsonDecode(response.body);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: WebViewWidget(controller: controller),
    );
  }
}
