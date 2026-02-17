import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isf_app/main.dart';
import 'package:isf_app/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:screenshot/screenshot.dart';

class RegistrationSuccessScreen extends StatefulWidget {
  final String name;
  final String appNo; // changed from reference
  final String category;
  final String eventName;
  final String eventDate;
  final String venue;

  const RegistrationSuccessScreen({
    super.key,
    required this.name,
    required this.appNo,
    required this.category,
    required this.eventName,
    required this.eventDate,
    required this.venue,
  });

  @override
  State<RegistrationSuccessScreen> createState() =>
      _RegistrationSuccessScreenState();
}

class _RegistrationSuccessScreenState extends State<RegistrationSuccessScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  String eventDate = 'Loading...';
  String venue = 'Loading...';
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    try {
      final url =
          Uri.parse('https://360globalnetwork.com.ng/isf2025/get_event.php');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          eventDate = data['event_date'] ?? 'N/A';
          venue = data['venue'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        setState(() {
          eventDate = 'Error fetching date';
          venue = 'Error fetching venue';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        eventDate = 'Network Error';
        venue = 'Network Error';
        isLoading = false;
      });
    }
  }

  Future<void> captureScreen() async {
    try {
      setState(() => isSaving = true);

      // Capture screenshot as bytes
      final imageBytes = await screenshotController.capture(
        pixelRatio: 2.0,
      );

      if (imageBytes == null) throw 'Failed to capture screenshot';

      // Get public Download folder path
      final downloadPath = '/storage/emulated/0/Download';
      final fileName = 'registration_${widget.appNo}.png';
      final file = File('$downloadPath/$fileName');

      // Save file
      await file.writeAsBytes(imageBytes);

      setState(() => isSaving = false);

      // Notify user
      Get.snackbar(
        'Success',
        'Screenshot saved to Download/$fileName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() => isSaving = false);
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Screenshot(
          controller: screenshotController,
          child: RefreshIndicator(
            onRefresh: _fetchEventDetails,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle,
                      size: 100, color: Colors.green),
                  const SizedBox(height: 20),
                  const Text(
                    'Registration Complete!',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Congratulations ${widget.name}!',
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You have successfully registered for:\n${widget.category}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Your Registration Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          ListTile(
                            leading: const Icon(Icons.confirmation_number),
                            title: const Text('Application Number'),
                            subtitle: Text(widget.appNo),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Event Date'),
                            subtitle: Text(eventDate),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.location_on),
                            title: const Text('Venue'),
                            subtitle: Text(venue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => Get.offAll(() => MarathonRegistrationScreen()),
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 59, 59, 223), // Blue
                            Color.fromARGB(255, 1, 44, 3), // Green
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: isSaving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.camera_alt, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Register Another Person',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                      "Please keep a screenshot of this page for your records.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color.fromARGB(255, 19, 224, 101),
                          fontSize: 16)),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () {
                      Get.offAll(() => HomeCarouselPage());
                    },
                    child: const Text(
                      'Go to Home',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
