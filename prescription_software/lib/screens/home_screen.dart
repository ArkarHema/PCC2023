import 'package:flutter/material.dart';
import 'package:prescription_software/widgets/content/PatientsWidget.dart';
import 'package:prescription_software/widgets/content/TrackWidget.dart';
import 'package:prescription_software/dialogs/DoctorEditProfile.dart';
import 'package:prescription_software/screens/login_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({required this.token, super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> jwtDecodedToken;
  String currentContent = 'prescriptions';

  @override
  void initState() {
    super.initState();
    jwtDecodedToken = JwtDecoder.decode(widget.token);
  }

  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on "No"
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true on "Yes"
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _changeContent(String content) {
    setState(() {
      currentContent = content;
    });
  }

  Widget _buildContent() {
    switch (currentContent) {
      case 'prescriptions':
        return PatientsWidget(token: widget.token);
      case 'track':
        return const new_line();
      default:
        return Container(); // Default content (empty)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Section
          Container(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Dr. ${jwtDecodedToken['fullName']}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                // Edit Profile button
                ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: () {
                    // Open the Edit Profile dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DoctorEditProfileDialog(
                          profile: jwtDecodedToken['_id'],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.description,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Prescriptions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: () {
                    _changeContent('prescriptions');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.track_changes,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Track',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: () {
                    _changeContent('track');
                  },
                ),

                Spacer(),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  onTap: () async {
                    final logoutConfirmed =
                        await _showLogoutConfirmationDialog(context);
                    if (logoutConfirmed == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }
                  },
                ),
              ],
            ),
          ),
          // Main Content Section
          Expanded(
            child: Container(
              child: Center(child: _buildContent()),
            ),
          ),
        ],
      ),
    );
  }
}
