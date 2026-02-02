import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'aboutisf.dart';
import 'isffootball.dart';
import 'register.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ISFApp(),
  );
}

class ISFApp extends StatelessWidget {
  const ISFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Iyekhei Sport Festival (ISF)',
      debugShowCheckedModeBanner: false,
      home: HomeCarouselPage(),
    );
  }
}

class HomeCarouselPage extends StatelessWidget {
  // First Slide
  final List<Widget> carouselSlides = [
    // First Slide
    Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Winners ISF 2024 Football',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // SizedBox(height: 16),
          Image.asset(
            'assets/images/1.jpeg',
            height: 150,
            width: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Placeholder(
              fallbackHeight: 150,
              fallbackWidth: 300,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),

    // Second Slide
    Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '2024 ISF Marathon Winners',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          //SizedBox(height: 16),
          Image.asset(
            'assets/images/2.jpeg',
            height: 150,
            width: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Placeholder(
              fallbackHeight: 150,
              fallbackWidth: 300,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),

    // Third Slide (Fixed)
    Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ISF Marathon 8th Edition',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          //SizedBox(height: 16),
          Image.asset(
            'assets/images/isfmarathon.jpeg',
            height: 150,
            width: 300,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image: $error');
              return Container(
                height: 150,
                width: 300,
                color: Colors.black,
                child: Center(
                  child: Icon(Icons.error, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    ),
  ];

  HomeCarouselPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        //title: const Text('Iyekhei Sport Festival (ISF)'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'MENU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.blueAccent,
              ),
              title: Text('HOME'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.blueAccent,
              ),
              title: Text('ABOUT ISF'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUs(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.event,
                color: Colors.blueAccent,
              ),
              title: Text('ISF MARATHON 2025'),
              onTap: () {
                // Handle navigation to Events
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MarathonRegistrationScreen(), // Ensure this class is defined below or imported
                  ),
                );
              },
            ),
            ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sports_soccer, color: Colors.blueAccent),
                ],
              ),
              title: Text('ISF FOOTBALL'),
              subtitle: Text(
                'Fixtures,Table Standing, Scores and Updates',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WebViewScreen(), // Ensure this class is defined below or imported
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.contact_support,
                color: Colors.blueAccent,
              ),
              title: Text('CONTACT US'),
              onTap: () {
                // Handle navigation to Contact Us
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel Section
            CarouselSlider(
              items: carouselSlides,
              options: CarouselOptions(
                height: 300, // Adjust height for the carousel
                autoPlay: true, // Enable automatic sliding
                enlargeCenterPage: true, // Highlight the current slide
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.blueAccent,
              indent: 16,
              endIndent: 16,
            ),
            // Registration Button Section
            Container(
              margin: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Implement registration functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MarathonRegistrationScreen(), // Ensure this class is defined below or imported
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: Text(
                  ' ISF MARATHON 2025 REGISTRATION',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.blueAccent,
              indent: 16,
              endIndent: 16,
            ),
            SizedBox(height: 12),
            Text(
              "The Iyekhei Sport Festival (ISF) is an annual festival for various sporting activities managed by the Iyekhei Sport Festival Committee (ISFC), which is a committee under the Auchi Dynamic Youth Association (Zone E) Iyekhei. "
              "The ISF was initiated under the reign of Abubakar Abdulazeez in 2018 to organise annual sporting activities aimed at bringing out the spirit of sportsmanship from Iyekhei sons, daughters, and other individuals.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.5, // Line height adjustment for better readability
              ),
            ),
            SizedBox(height: 15),
            // Quick Stats Section
            Container(
              color: const Color.fromARGB(255, 28, 27, 27),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CounterWidget(label: 'Expected Athletes', count: '3000+'),
                  CounterWidget(label: 'Supporters', count: '20000+'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final String label;
  final String count;

  const CounterWidget({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
