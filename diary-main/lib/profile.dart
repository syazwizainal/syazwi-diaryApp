import 'package:flutter/material.dart';
import 'sql_helper.dart';
import 'settings.dart';
import 'analysis.dart';
import 'homepage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 3;
  String _feelingText = "You Are In Neutral"; // Default feeling text
  String _currentFeeling = "Neutral";

  void _onTabTapped(int index) {
    // Handle navigation to the desired class or widget here
    if (index == 0) {
      // Navigate to AnalysisScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      // Navigate to MoodScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AnalysisScreen()),
      );
    } else if (index == 2) {
      // Navigate to SettingScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingScreen()),
      );
    } else if (index == 3) {
      // Navigate to ProfileScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  Map<String, String> gifAssets = {
    'Happy': 'assets/images/happy.gif',
    'Sad': 'assets/images/sad.gif',
    'Excited': 'assets/images/excited.gif',
    'Angry': 'assets/images/angry.gif',
    'Stressed': 'assets/images/stressed.gif',
    'Neutral': 'assets/images/neutral.gif',
    // Add more feelings and their corresponding gif assets as needed
  };

  Map<String, String> feelingQuotes = {
    'Happy': 'A smile is a curve that sets everything straight.',
    'Sad': 'Tears are words the heart cant express',
    'Excited': 'If being happy was a crime, I do be the most wanted criminal.',
    'Angry': 'The best answer to anger is silence',
    'Stressed': 'Dont stress too much',
    'Neutral': 'Life is short, take the trip.',
    // Add more feelings and their corresponding gif assets as needed
  };

  Future<List<Map<String, dynamic>>> getDiaries() async {
    final db = await SQLHelper
        .db(); // Replace 'database' with your method to get the database instance
    return await db.query('diary'); // Replace 'diaries' with your table name
  }

  Future<void> updateFeelingText() async {
    try {
      final List<Map<String, dynamic>> diaries = await getDiaries();
      if (diaries.isNotEmpty) {
        // Assuming the 'feeling' column holds the feeling text in the database
        final String latestFeeling = diaries.last['feeling'];
        setState(() {
          _feelingText = "I Feel $latestFeeling";
          _currentFeeling = latestFeeling;
        });
      }
    } catch (e) {
      print("Error fetching data from the database: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    updateFeelingText(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(
                    gifAssets[_currentFeeling] ?? gifAssets['Neutral']!,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      _feelingText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    feelingQuotes[_currentFeeling] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: Icon(Icons.mood),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.green,
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
