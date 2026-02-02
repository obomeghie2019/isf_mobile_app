import 'package:flutter/material.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  _SampleScreenState createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  int _currentIndex = 0; // Tracks the selected tab

  // Bottom Navigation Bar Items
  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports_soccer),
      label: 'Matches',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      label: 'Events',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'About Us',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('ISF Football Festival 2025'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
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
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: _bottomNavItems,
      ),
    );
  }

  Widget _buildAlertCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
      color: const Color.fromARGB(255, 39, 36, 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildServiceIcon(Icons.tv, 'ISF Football\nLive Scores', () {}),
            _buildServiceIcon(Icons.event_sharp, 'ISF 2025 \nEvents', () {}),
            _buildServiceIcon(Icons.sports_esports, 'ISF 2025\nGames', () {}),
            _buildServiceIcon(
                Icons.event_available, 'ISF Football\nFixtures', () {}),
            _buildServiceIcon(
                Icons.leaderboard, 'ISF Football\nStandings', () {}),
            _buildServiceIcon(
                Icons.newspaper_sharp, 'ISF News\nUpdates', () {}),
            _buildServiceIcon(Icons.info, 'About ISF', () {}),
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
              backgroundColor: Colors.grey.shade800,
              radius: 30,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 9),
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
      color: const Color.fromARGB(255, 8, 57, 23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.campaign, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Are you ready for ISF Marathon 6KM Race?',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 68, 77, 206),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Register Now',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
