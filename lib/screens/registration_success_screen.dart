import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isf_app/register.dart';

// lib/screens/registration_success_screen.dart
class RegistrationSuccessScreen extends StatelessWidget {
  final String name;
  final String reference;
  final String category;

  const RegistrationSuccessScreen({
    super.key,
    required this.name,
    required this.reference,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 100, color: Colors.green),
              SizedBox(height: 30),
              Text(
                'Registration Complete!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Congratulations $name!',
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
              SizedBox(height: 10),
              Text(
                'You have successfully registered for:\n$category',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Your Registration Details',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      ListTile(
                        leading: Icon(Icons.confirmation_number),
                        title: Text('Reference Number'),
                        subtitle: Text(reference),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text('Event Date'),
                        subtitle: Text('December 25, 2025'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('Venue'),
                        subtitle: Text('National Stadium, Lagos'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Share registration details
                },
                icon: Icon(Icons.share),
                label: Text('Share Registration'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(200, 50),
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Get.offAll(() => MarathonRegistrationScreen());
                },
                child: Text('Register Another Person'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
