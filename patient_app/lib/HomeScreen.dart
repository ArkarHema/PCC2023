import 'package:flutter/material.dart';
import 'package:gehealth_care/Chatbot.dart';
import 'package:gehealth_care/refill.dart';
import 'package:gehealth_care/track.dart';
import 'package:gehealth_care/UserScreen.dart';

class homeScreen extends StatefulWidget {
  final String patientId;
  final List<String> preferredTime;
  const homeScreen(
      {super.key, required this.patientId, required this.preferredTime});
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = []; // Initialize the _pages list here

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      UserScreen(
          patientId: widget.patientId, preferredTime: widget.preferredTime),
      refill(patientId: widget.patientId),
      AdherenceTrackingScreen(),
      chatbot(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Refill',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chatbot',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
