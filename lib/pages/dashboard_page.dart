import 'package:flutter/material.dart';
import './profile_page.dart';
import './activity_detail_page.dart';
import './alerts_page.dart';
import './explore_page.dart';
import './help_page.dart';
import './settings_page.dart';
import './stats_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _selectedCard = -1;

  // Local list of activities (in-memory)
  List<String> _activities = ["Stat 1", "Stat 2", "Stat 3", "Stat 4"];

  // Animation-related controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();

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
        _controller.forward(from: 0); // Restart animation

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
                    child: Icon(Icons.directions_run, size: 50, color: Colors.blue),
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
                          setState(() {
                            _activities.add(title);
                          });
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
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Already on Dashboard
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StatsPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AlertsPage()));
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Welcome, Naeem", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Help"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => HelpPage()));
              },
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
                setState(() {
                  _selectedCard = index;
                });

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 0) {
            setState(() => _currentIndex = index); // Stay on Dashboard
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ExplorePage()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddActivityPanel,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
