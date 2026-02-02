import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'package:isf_app/isffixtures.dart';
import 'package:isf_app/isfnews.dart';
import 'package:isf_app/isfstanding.dart';
import 'package:isf_app/isfstatistics.dart';
import 'aboutisf.dart';
import 'isffootball.dart';
import 'register.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MobileAds.instance.initialize();
  runApp(const ISFApp());
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

class HomeCarouselPage extends StatefulWidget {
  const HomeCarouselPage({super.key});

  @override
  State<HomeCarouselPage> createState() => _HomeCarouselPageState();
}

class _HomeCarouselPageState extends State<HomeCarouselPage> {
  int _currentIndex = 0; // Tracks the selected tab
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isConnected = true; // Default to connected

  @override
  void initState() {
    super.initState();

    // Listen for network changes (new API returns a List<ConnectivityResult>)
    _subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // Consider connected if any result is not 'none'
      bool hasInternet = results.any(
        (result) => result != ConnectivityResult.none,
      );
      if (_isConnected != hasInternet) {
        setState(() {
          _isConnected = hasInternet;
        });
        _showNetworkStatusPopup();
      }
    });
  }

  void _showNetworkStatusPopup() {
    final message =
        _isConnected ? "Internet Restored!" : "No Internet Connection!";
    final color = _isConnected ? Colors.green : Colors.red;

    Get.snackbar(
      "Network Status", // Title
      message, // Message
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _subscription.cancel(); // Dispose of listener to prevent memory leaks
    super.dispose();
  }

  // Bottom Navigation Bar Items
  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Live'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Events'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'About Us'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 59, 59, 223),
        //title: const Text('Iyekhei Sport Festival (ISF)'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:
                  BoxDecoration(color: const Color.fromARGB(255, 59, 59, 223)),
              child: Text(
                'MENU',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home,
                  color: const Color.fromARGB(255, 59, 59, 223)),
              title: Text('HOME'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.info,
                  color: const Color.fromARGB(255, 59, 59, 223)),
              title: Text('ABOUT ISF'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event,
                  color: const Color.fromARGB(255, 59, 59, 223)),
              title: Text('ISF MARATHON'),
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
            //Ads Banner
            // BannerAdWidget(
            // adUnitId: 'ca-app-pub-8686875793330353/6579589869',
            // ),
            ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sports_soccer,
                      color: const Color.fromARGB(255, 59, 59, 223))
                ],
              ),
              title: Text('ISF FOOTBALL'),
              subtitle: Text(
                'Fixtures,Table Standing, Scores and Updates',
                style: TextStyle(color: Colors.black, fontSize: 10),
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
              leading: Icon(Icons.contact_support,
                  color: const Color.fromARGB(255, 59, 59, 223)),
              title: Text('CONTACT US'),
              onTap: () {
                // Handle navigation to Contact Us
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AboutUs(), // Ensure this class is defined below or imported
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _buildAlertCard(),
            const SizedBox(height: 16),
            _buildServiceGrid(),
            const SizedBox(height: 16),
            _buildInviteBonusCard(),
          ],
        ),
      ),

      //Ads Banner
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Add navigation logic here (e.g., using Navigator.push)
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color.fromARGB(255, 59, 59, 223),
        unselectedItemColor: Colors.grey,
        items: _bottomNavItems,
      ),
    );
  }

  Widget _buildAlertCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/isfbanner.png',
          width: double.infinity,
          height: 150, // Increased height for better visibility
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildServiceGrid() {
    return Card(
      color: const Color.fromARGB(255, 14, 16, 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildServiceIcon(Icons.tv, 'ISF Live Scores', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebViewScreen()),
              );
            }),
            _buildServiceIcon(Icons.event_sharp, 'ISF Statistics', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ISFstatisticscreen()),
              );
            }),
            _buildServiceIcon(Icons.sports_esports, 'ISF Games', () {}),
            _buildServiceIcon(
              Icons.event_available,
              'ISF Fixtures',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ISFfixtureScreen()),
                );
              },
            ),
            _buildServiceIcon(Icons.leaderboard, 'ISF Standings', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ISFStanding()),
              );
            }),
            _buildServiceIcon(Icons.newspaper_sharp, 'ISF Updates', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ISFNewsScreen()),
              );
            }),
            _buildServiceIcon(Icons.info, 'About ISF', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUs()),
              );
            }),
            _buildServiceIcon(Icons.more_horiz, 'More', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 59, 59, 223),
              radius: 30,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 9),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteBonusCard() {
    return Card(
      color: const Color.fromARGB(255, 59, 59, 223),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.campaign, color: Colors.white),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Are you ready for 6KM Race?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 8, 104, 54),
                          Color.fromARGB(255, 3, 20, 54)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      //Proceed To Pay
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MarathonRegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
