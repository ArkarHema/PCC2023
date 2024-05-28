import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class refill extends StatefulWidget {
  final String patientId;

  const refill({super.key, required this.patientId});

  @override
  State<refill> createState() => _refillState();
}

class _refillState extends State<refill> {
  final TextEditingController _count = TextEditingController();
  String count = '1';
  List<dynamic> medicines = [];

  Future<void> fetchMedicines(String patientId) async {
    try {
      final serverUrl = dotenv.env['SERVER_URL'];
      final response = await http
          .get(Uri.parse('$serverUrl/patients/prescriptions/$patientId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<dynamic> fetchedMedicines = data.expand((item) {
          // Use the 'medicines' field if it's a list in your JSON structure
          final medicines = item['medicines'];

          if (medicines is List) {
            // Filter medicines based on your criteria
            return medicines.where((medicine) =>
                medicine['quantity'] <= 3 && medicine['refill'] > 0);
          } else {
            return [];
          }
        }).toList();

        setState(() {
          medicines = fetchedMedicines;
          print(medicines);
        });
      } else {
        throw Exception('Failed to fetch prescription data');
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMedicines(widget.patientId); // Fetch medicines during initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refill Needed'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width *
                      0.9, // One-third of the screen width
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4), // Decreased opacity
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Click on any medicine to adjust stock',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey, // Text color set to black
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Medications running low',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Text color set to black
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          // Display filtered medicines here
                          Column(
                            children: medicines.map((medicine) {
                              return ListTile(
                                title: Text(
                                  medicine['medicationName'],
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    // Construct and launch the URL
                                    final url =
                                        'https://pharmeasy.in/search/all?name=${Uri.encodeComponent(medicine['medicationName'])}%20${Uri.encodeComponent(medicine['dosage'])}';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: const Text('Buy Now'),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
