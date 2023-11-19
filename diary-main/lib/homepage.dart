import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sql_helper.dart';
import 'analysis.dart';
import 'profile.dart';
import 'settings.dart';

String? selectedFeeling;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> gifAssets = {
    'Happy': 'assets/images/happy.gif',
    'Sad': 'assets/images/sad.gif',
    'Excited': 'assets/images/excited.gif',
    'Angry': 'assets/images/angry.gif',
    'Stressed': 'assets/images/stressed.gif',
    'Neutral': 'assets/images/neutral.gif',
    // Add more feelings and their corresponding gif assets as needed
  };

  List<String> feelings = [
    'Happy',
    'Sad',
    'Angry',
    'Excited',
    'Neutral',
    'Stressed',
    // Add more feelings as needed
  ];

  final Map<String, IconData> activityIcons = {
    'Running': Icons.directions_run,
    'Swimming': Icons.pool,
    'Cycling': Icons.directions_bike,
    'Reading': Icons.menu_book,
    'Cooking': Icons.restaurant,
  };

  bool isActivity1Checked = false;
  bool isActivity2Checked = false;
  bool isActivity3Checked = false;
  bool isActivity4Checked = false;
  bool isActivity5Checked = false;

  final int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AnalysisScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  List<Map<String, dynamic>> _diaries = [];
  bool _isLoading = true;

  void _refreshDiaries() async {
    final data = await SQLHelper.getDiaries();
    setState(() {
      _diaries = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshDiaries();
  }

  final TextEditingController _feelingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingDiary =
          _diaries.firstWhere((element) => element['id'] == id);
      _feelingController.text = existingDiary['feeling'];
      _descriptionController.text = existingDiary['description'];
      _activityController.text =
          existingDiary['activity']; // Set the activity text in the form
    } else {
      _feelingController.text = '';
      _descriptionController.text = '';
      _activityController.text = ''; // Clear the activity field in the form
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 30),
              const Row(
                children: [
                  Text(
                    'Create Your Diary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: selectedFeeling,
                  hint: const Text('Select Feeling'), // Placeholder text
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFeeling = newValue;
                    });
                  },
                  items: feelings.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  icon: const Icon(
                      Icons.arrow_drop_down), // Add the trailing arrow icon
                  iconSize: 24, // Set the size of the arrow icon
                  isExpanded:
                      true, // Set to true to make the dropdown take up the full width
                  underline: SizedBox(), // Remove the default underline
                ),
              ),

              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  // Add a border around the TextField
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey, // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Border radius
                  ),
                  contentPadding: const EdgeInsets.all(
                      16.0), // Padding inside the TextField
                ),
              ),

              const SizedBox(height: 30),
              // ignore: avoid_unnecessary_containers
              const Row(
                children: [
                  Icon(
                    Icons.directions_run, // Change this to your desired icon
                    color: Colors.teal, // Change the color as needed
                  ),
                  SizedBox(width: 8),
                  Text(
                    'What is your activity?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                  height:
                      10), // Add spacing between description and activity fields
              ListTile(
                title: const Text('Running'),
                leading: Checkbox(
                  value: isActivity1Checked,
                  onChanged: (value) {
                    setState(() {
                      isActivity1Checked = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Swimming'),
                leading: Checkbox(
                  value: isActivity2Checked,
                  onChanged: (value) {
                    setState(() {
                      isActivity2Checked = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Cycling'),
                leading: Checkbox(
                  value: isActivity3Checked,
                  onChanged: (value) {
                    setState(() {
                      isActivity3Checked = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Reading'),
                leading: Checkbox(
                  value: isActivity4Checked,
                  onChanged: (value) {
                    setState(() {
                      isActivity4Checked = value ?? false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Cooking'),
                leading: Checkbox(
                  value: isActivity5Checked,
                  onChanged: (value) {
                    setState(() {
                      isActivity5Checked = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 300, // Adjust the width as needed
                  child: ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addDiary();
                      } else {
                        await _updateDiary(id);
                      }
                      _feelingController.text = '';
                      _descriptionController.text = '';
                      _activityController.text =
                          ''; // Clear the activity field after submission
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Colors.green, // Set the background color to green
                    ),
                    child: Text(id == null ? 'Create New' : 'Update'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addDiary() async {
    String activities = '';

    if (isActivity1Checked) activities += 'Running, ';
    if (isActivity2Checked) activities += 'Swimming, ';
    if (isActivity3Checked) activities += 'Cycling, ';
    if (isActivity4Checked) activities += 'Reading, ';
    if (isActivity5Checked) activities += 'Cooking, ';

    // Remove the trailing comma and space if there are any activities
    if (activities.isNotEmpty) {
      activities = activities.substring(0, activities.length - 2);
    }

    await SQLHelper.createDiary(
      selectedFeeling ?? '',
      _descriptionController.text,
      activities, // Pass the activities as a comma-separated string
    );
    _refreshDiaries();
  }

  Future<void> _updateDiary(int id) async {
    String activities = '';

    if (isActivity1Checked) activities += 'Running, ';
    if (isActivity2Checked) activities += 'Swimming, ';
    if (isActivity3Checked) activities += 'Cycling, ';
    if (isActivity4Checked) activities += 'Reading, ';
    if (isActivity5Checked) activities += 'Cooking, ';

    // Remove the trailing comma and space if there are any activities
    if (activities.isNotEmpty) {
      activities = activities.substring(0, activities.length - 2);
    }

    await SQLHelper.updateDiary(
      id,
      selectedFeeling ?? '',
      _descriptionController.text,
      activities, // Pass the selected activity icons as a List<String>
    );
    _refreshDiaries();
  }

  Future<void> _deleteDiary(int id) async {
    await SQLHelper.deleteDiary(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a diary!'),
    ));
    _refreshDiaries();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Color> feelingColors = {
      'Happy': Theme.of(context).brightness == Brightness.light
          ? Colors.yellow.shade200
          : Colors.yellow.shade800,
      'Sad': Theme.of(context).brightness == Brightness.light
          ? Colors.grey.shade400
          : Colors.grey.shade600,
      'Excited': Theme.of(context).brightness == Brightness.light
          ? Colors.orange.shade200
          : const Color.fromARGB(255, 153, 90, 38),
      'Angry': Theme.of(context).brightness == Brightness.light
          ? Colors.red.shade200
          : const Color.fromARGB(255, 149, 33, 33),
      'Stressed': Theme.of(context).brightness == Brightness.light
          ? Colors.blue.shade200
          : Colors.blue.shade800,
      'Neutral': Theme.of(context).brightness == Brightness.light
          ? Colors.green.shade200
          : Colors.green.shade800,
      // Add more feelings and their corresponding colors as needed
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Diary"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _diaries.length,
              itemBuilder: (context, index) => Card(
                elevation: 4, // Adjust the elevation for the card's shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Adjust the corner radius as desired
                  side: const BorderSide(
                      color: Colors.grey, width: 0.5), // Add a border if needed
                ),
                color: feelingColors[_diaries[index]['feeling']] ??
                    Colors.tealAccent,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Image.asset(
                      gifAssets[_diaries[index]['feeling']] ??
                          'assets/images/neutral.gif',
                    ),
                    backgroundColor: Colors.tealAccent,
                  ),
                  title: Text(_diaries[index]['feeling']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_diaries[index]['description']),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: [
                          for (String activity
                              in _diaries[index]['activity'].split(', '))
                            Chip(
                              backgroundColor: Colors.transparent,
                              label: Icon(
                                activityIcons[activity] ??
                                    Icons.nightlight_outlined,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors
                                        .white // Change icon color to white for dark mode
                                    : Colors
                                        .black, // Change icon color to black for light mode
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('dd-MM-yyyy   hh:mm a').format(
                          DateTime.parse(_diaries[index]['createdAt']),
                        ),
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          onPressed: () => _showForm(_diaries[index]['id']),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteDiary(_diaries[index]['id']),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
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
