import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gehealth_care/UserScreen.dart';

class PrescriptionCard extends StatefulWidget {
  final PrescriptionData prescriptionData;

  const PrescriptionCard({
    Key? key,
    required this.prescriptionData,
  }) : super(key: key);

  @override
  _PrescriptionCardState createState() => _PrescriptionCardState();
}

class _PrescriptionCardState extends State<PrescriptionCard> {
  bool isFront = true;

  void toggleCardSide() {
    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCardSide,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: isFront
            ? FrontCard(prescriptionData: widget.prescriptionData)
            : BackCard(medications: widget.prescriptionData.medications),
      ),
    );
  }
}

class FrontCard extends StatelessWidget {
  final PrescriptionData prescriptionData;

  const FrontCard({
    Key? key,
    required this.prescriptionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prescription Details',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Duration: ${prescriptionData.duration} days',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Doctor License Number: ${prescriptionData.doctorLicenseNumber}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Organization: ${prescriptionData.organization}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Prescription Date: ${DateFormat('yyyy-MM-dd').format(prescriptionData.prescriptionDate)}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Prescription End Date:  ${DateFormat('yyyy-MM-dd').format(prescriptionData.prescriptionDate.add(Duration(days: int.parse(prescriptionData.duration) - 1)))}',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            'Vital Signs:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Temperature: ${prescriptionData.vitalSigns['temperature']}°F',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Blood Pressure: ${prescriptionData.vitalSigns['bloodPressure']} mmHg',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Diagnosis: ${prescriptionData.diagnosis}',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class BackCard extends StatelessWidget {
  final List<Map<String, dynamic>> medications;

  const BackCard({
    Key? key,
    required this.medications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medications:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          for (final medication in medications)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medication Name: ${medication['name']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Dosage: ${medication['dosage']}',
                  style: TextStyle(fontSize: 16.0),
                ),
                // Add more medication details as needed
              ],
            ),
        ],
      ),
    );
  }
}
