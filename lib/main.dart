import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  int _currentIndex = 0;
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isConnected = true;

  // ── Marathon registration state ──
  bool _marathonOpen = false; // false = closed, true = open
  bool _loadingMarathon = true; // shows shimmer while fetching

  // ── CHANGE THIS to your actual API URL ──
  static const String _apiUrl =
      'https://360globalnetwork.com.ng/isf2025/mobile_settings.php';

  @override
  void initState() {
    super.initState();
    _fetchMarathonStatus();

    _subscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        bool hasInternet = results.any((r) => r != ConnectivityResult.none);
        if (_isConnected != hasInternet) {
          setState(() => _isConnected = hasInternet);
          _showNetworkStatusPopup();
          // Re-fetch when internet is restored
          if (hasInternet) _fetchMarathonStatus();
        }
      },
    );
  }

  // ── Fetch marathon_registration from your PHP API ──
  Future<void> _fetchMarathonStatus() async {
    setState(() => _loadingMarathon = true);
    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _marathonOpen = (data['marathon_registration'] == 'open');
          _loadingMarathon = false;
        });
      } else {
        setState(() => _loadingMarathon = false);
      }
    } catch (e) {
      // Network error – default to closed for safety
      setState(() => _loadingMarathon = false);
    }
  }

  void _showNetworkStatusPopup() {
    final message =
        _isConnected ? "Internet Restored!" : "No Internet Connection!";
    final color = _isConnected ? Colors.green : Colors.red;
    Get.snackbar(
      "Network Status",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 59, 59, 223)),
              child: const Text(
                'MENU',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home,
                  color: Color.fromARGB(255, 59, 59, 223)),
              title: const Text('HOME'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info,
                  color: Color.fromARGB(255, 59, 59, 223)),
              title: const Text('ABOUT ISF'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AboutUs())),
            ),
            // ── Marathon drawer item: only shown when OPEN ──
            if (_marathonOpen)
              ListTile(
                leading: const Icon(Icons.event,
                    color: Color.fromARGB(255, 59, 59, 223)),
                title: const Text('ISF MARATHON'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MarathonRegistrationScreen()),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.sports_soccer,
                  color: Color.fromARGB(255, 59, 59, 223)),
              title: const Text('ISF FOOTBALL'),
              subtitle: const Text(
                'Fixtures, Table Standing, Scores and Updates',
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => WebViewScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.contact_support,
                  color: Color.fromARGB(255, 59, 59, 223)),
              title: const Text('CONTACT US'),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AboutUs())),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchMarathonStatus, // pull-to-refresh re-checks status
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              _buildAlertCard(),
              const SizedBox(height: 16),
              _buildServiceGrid(),
              const SizedBox(height: 16),
              // ── Marathon card: controlled by toggle ──
              _buildMarathonCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color.fromARGB(255, 59, 59, 223),
        unselectedItemColor: Colors.grey,
        items: _bottomNavItems,
      ),
    );
  }

  // ── Banner card (unchanged) ──
  Widget _buildAlertCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/isfbanner.png',
          width: double.infinity,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ── Service grid (unchanged) ──
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
                  context, MaterialPageRoute(builder: (_) => WebViewScreen()));
            }),
            _buildServiceIcon(Icons.event_sharp, 'ISF Statistics', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ISFstatisticscreen()));
            }),
            _buildServiceIcon(Icons.sports_esports, 'ISF Games', () {}),
            _buildServiceIcon(Icons.event_available, 'ISF Fixtures', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ISFfixtureScreen()));
            }),
            _buildServiceIcon(Icons.leaderboard, 'ISF Standings', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ISFStanding()));
            }),
            _buildServiceIcon(Icons.newspaper_sharp, 'ISF Updates', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ISFNewsScreen()));
            }),
            _buildServiceIcon(Icons.info, 'About ISF', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AboutUs()));
            }),
            _buildServiceIcon(Icons.more_horiz, 'More', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(
      IconData icon, String label, VoidCallback onPressed) {
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

  // ── Marathon card – dynamically shows OPEN or CLOSED state ──
  Widget _buildMarathonCard() {
    // While loading show a shimmer-style placeholder
    if (_loadingMarathon) {
      return Card(
        color: const Color.fromARGB(255, 59, 59, 223),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    // ── REGISTRATION OPEN ──
    if (_marathonOpen) {
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
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 8, 104, 54),
                          Color.fromARGB(255, 3, 20, 54),
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
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MarathonRegistrationScreen()),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── REGISTRATION CLOSED ──
    return Card(
      color: const Color.fromARGB(255, 59, 59, 223),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.lock_outline,
                  color: Colors.redAccent, size: 28),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Marathon Registration',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ISF Marathon Registration is closed!',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.redAccent, width: 1),
              ),
              child: const Text(
                'CLOSED',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
