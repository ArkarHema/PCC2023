import 'package:flutter/material.dart';
import 'package:gehealth_care/HomeScreen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class splashScreen extends StatefulWidget {
  final String patientId;
  List<String> preferredTime;
  splashScreen(
      {super.key, required this.patientId, required this.preferredTime});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'MEN3vKE1WrQ',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0), // Adjust the spacing as needed
            const Text(
              'Introductory Video',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color set to black
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width *
                  0.9, // One-third of the screen width
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent
                    .withOpacity(0.4), // Decreased opacity
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => homeScreen(
                                  patientId: widget.patientId,
                                  preferredTime: widget.preferredTime),
                            ),
                          );
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
