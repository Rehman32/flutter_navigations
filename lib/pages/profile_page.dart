import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "Achievements"),
            Tab(text: "Goals"),
            Tab(text: "About"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Achievements
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text("🏆 5K Steps Badge"),
              Text("🔥 7-Day Streak"),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showMore = !_showMore;
                  });
                },
                child: Text(_showMore ? "Hide" : "Show More"),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: _showMore ? 1.0 : 0.0,
                child: Column(
                  children: [
                    Text("⭐ Monthly Goal Reached"),
                    Text("🚀 Fitness Champion"),
                  ],
                ),
              ),
            ],
          ),

          // Goals
          Center(child: Text("🎯 Set your next goal here!")),

          // About
          Center(
            child: Text(
              "💡 This is your personal fitness space.\nBuilt with Flutter 💙",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
