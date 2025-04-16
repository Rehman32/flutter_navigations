import 'package:flutter/material.dart';

class ActivityDetailPage extends StatelessWidget {
  final int index;
  final String title;

  const ActivityDetailPage({super.key, required this.index, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Hero(
          tag: 'activity-card-$index',
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "$title Details",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
