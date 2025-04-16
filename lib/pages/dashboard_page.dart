import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './profile_page.dart';
import './activity_detail_page.dart';
import './stats_page.dart';
import './alerts_page.dart';
import './settings_page.dart';
import './help_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  int _selectedCard = -1;
  List<String> _activities = [];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadActivities();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.3)),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.3, 0.6, curve: Curves.easeOut)),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.elasticOut)),
    );
  }

  Future<void> _saveActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('activities', jsonEncode(_activities));
  }

  Future<void> _loadActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('activities');

    if (data != null) {
      setState(() {
        _activities = List<String>.from(jsonDecode(data));
      });
    } else {
      setState(() {
        _activities = ["Stat 1", "Stat 2", "Stat 3", "Stat 4"];
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddActivityPanel() {
    TextEditingController _activityController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        _controller.forward(from: 0);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Icon(Icons.fitness_center, size: 50, color: Colors.blue),
                  ),
                  SizedBox(height: 16),
                  SlideTransition(
                    position: _slideAnimation,
                    child: TextField(
                      controller: _activityController,
                      decoration: InputDecoration(
                        labelText: "Activity Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ScaleTransition(
                    scale: _buttonScaleAnimation,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        String title = _activityController.text.trim();
                        if (title.isNotEmpty) {
                          setState(() => _activities.add(title));
                          _saveActivities();
                        }
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add Activity"),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, color: Colors.blue),
            ),
            SizedBox(width: 10),
            Text(
              "Welcome, Naeem",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StatsPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AlertsPage()));
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Naeem Ur Rehman"),
              accountEmail: Text("naeem@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text("Profile"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage())),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage())),
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Help"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpPage())),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(_activities.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() => _selectedCard = index);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailPage(
                      index: index,
                      title: _activities[index],
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'activity-card-$index',
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _selectedCard == index
                          ? [Colors.blueAccent, Colors.lightBlue]
                          : [Colors.blue[100]!, Colors.blue[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _selectedCard == index
                        ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      _activities[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddActivityPanel,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 28),
        elevation: 8,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.dashboard),
                onPressed: () {}, // Already on dashboard
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                },
              ),
              IconButton(onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
              },
                  icon: Icon(Icons.explore))
            ],
          ),
        ),
      ),
    );
  }
}
