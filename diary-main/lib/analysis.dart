import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'sql_helper.dart';
import 'settings.dart';
import 'homepage.dart';
import 'profile.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final int _currentIndex = 1;

  List<String> feelings = [
    'Happy',
    'Sad',
    'Excited',
    'Angry',
    'Stressed',
    'Neutral',
    // Add more feelings as needed
  ];

  Map<String, Color> feelingColors = {
    'Happy': Colors.yellow.shade200,
    'Sad': Colors.grey.shade400,
    'Excited': Colors.orange.shade200,
    'Angry': Colors.red.shade200,
    'Stressed': Colors.blue.shade200,
    'Neutral': Colors.green.shade200,
    // Add more feelings and their corresponding colors as needed
  };

  Map<String, Color> darkModeFeelingColors = {
    'Happy': Colors.yellow.shade800,
    'Sad': Colors.grey.shade600,
    'Excited': const Color.fromARGB(255, 153, 90, 38),
    'Angry': const Color.fromARGB(255, 149, 33, 33),
    'Stressed': Colors.blue.shade800,
    'Neutral': Colors.green.shade800,
    // Add more feelings and their corresponding colors as needed for dark mode
  };

// ...

  Map<String, Color> getCurrentFeelingColors(BuildContext context) {
    // Check if the current brightness is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Return the appropriate feeling colors map based on the theme mode
    return isDarkMode ? darkModeFeelingColors : feelingColors;
  }

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

  Future<List<Map<String, dynamic>>> getDiaries() async {
    final db = await SQLHelper
        .db(); // Replace 'database' with your method to get the database instance
    return await db.query('diary'); // Replace 'diaries' with your table name
  }

  Future<List<PieChartSectionData>> _generateChartData() async {
    final List<Map<String, dynamic>> diaries =
        await getDiaries(); // Fetch diaries from the database
    final int totalDiaryCount = diaries.length;

    return feelings.map((feeling) {
      final int count =
          diaries.where((diary) => diary['feeling'] == feeling).length;
      final double percentage = (count / totalDiaryCount) * 100;

      return PieChartSectionData(
        value: percentage,
        color: feelingColors[feeling] ?? Colors.tealAccent,
        title: feeling,
        radius: 100.0,
      );
    }).toList();
  }

  Widget _buildLegend(List<PieChartSectionData> chartData) {
    return SizedBox(
      width: 300, // Set the width as needed
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chartData.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: data.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${data.title}: ${data.value.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    feelingColors = getCurrentFeelingColors(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            FutureBuilder<List<PieChartSectionData>>(
              future: _generateChartData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While data is being fetched, show a loading indicator
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error while fetching data, handle it here
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Data has been fetched successfully, build the pie chart
                  final List<PieChartSectionData> chartData = snapshot.data!;
                  return AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        sections: chartData,
                        centerSpaceRadius: 50.0,
                        sectionsSpace: 2.0,
                        startDegreeOffset: -90,
                        centerSpaceColor: Colors.transparent,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<PieChartSectionData>>(
              future: _generateChartData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While data is being fetched, return an empty widget
                  return const SizedBox.shrink();
                } else if (snapshot.hasError) {
                  // If there's an error while fetching data, handle it here
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Data has been fetched successfully, build the legend
                  final List<PieChartSectionData> chartData = snapshot.data!;
                  return _buildLegend(chartData);
                }
              },
            ),
          ],
        ),
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
