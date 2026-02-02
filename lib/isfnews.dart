import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Adbanner.dart';

class ISFNewsScreen extends StatefulWidget {
  const ISFNewsScreen({super.key});

  @override
  State<ISFNewsScreen> createState() => _ISFNewsScreenState();
}

class _ISFNewsScreenState extends State<ISFNewsScreen> {
  late WebViewController _controller;
  bool isLoading = true; // Track the loading state

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true; // Show loading indicator
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false; // Hide loading indicator
            });
          },
        ),
      )
      ..loadRequest(
          Uri.parse('https://challenge.place/c/isf258thedition/news'));
  }

  Future<void> _refreshPage() async {
    setState(() {
      isLoading = true; // Show loading indicator during refresh
    });
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("ISF News Updates",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshPage, // Attach the refresh logic
              child: WebViewWidget(controller: _controller),
            ),
          ),
          BannerAdWidget(
            adUnitId: 'ca-app-pub-8686875793330353/6579589869',
          ),
          if (isLoading) // Show the loading indicator only when loading
            const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 2.0,
              ),
            ),
        ],
      ),
    );
  }
}
