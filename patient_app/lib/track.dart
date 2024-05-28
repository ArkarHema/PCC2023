import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import "package:percent_indicator/circular_percent_indicator.dart";

class AdherenceTrackingScreen extends StatefulWidget {
  @override
  _AdherenceTrackingScreenState createState() =>
      _AdherenceTrackingScreenState();
}

class _AdherenceTrackingScreenState extends State<AdherenceTrackingScreen> {
  int selectedPrescriptionIndex = 0;
  int selectedMedicineIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> prescriptionData =
        prescriptionList[selectedPrescriptionIndex];
    final List<Map<String, dynamic>> medicines =
        prescriptionData['medicines'] ?? [];

    // Calculate overall adherence percentage
    double overallAdherence = 0.0;
    int totalAdherenceRecords = 0;

    for (final medication in medicines) {
      final adherence = medication['adherence'] ?? [];
      totalAdherenceRecords += adherence.length as int;

      for (final record in adherence) {
        if (record['morning']['taken'] &&
            record['afternoon']['taken'] &&
            record['night']['taken']) {
          overallAdherence += 1.0;
        }
      }
    }

    overallAdherence /= totalAdherenceRecords;

    // Create a list of BarChartGroupData based on adherence data
    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < medicines.length; i++) {
      final medication = medicines[i];
      final adherence = medication['adherence'] ?? [];
      final List<BarChartRodData> rods = [];

      for (int j = 0; j < adherence.length; j++) {
        final adherenceRecord = adherence[j];
        final int totalDoses = adherenceRecord['morning']['taken'] &&
                adherenceRecord['afternoon']['taken'] &&
                adherenceRecord['night']['taken']
            ? 3
            : 0; // Total doses based on morning, afternoon, and night

        rods.add(BarChartRodData(
          toY: totalDoses.toDouble(),
          width: 12,
          color: totalDoses == 3 ? Colors.green : Colors.red,
        ));
      }

      barGroups.add(BarChartGroupData(
        x: i,
        barRods: rods,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Adherence Tracking - Prescription ${selectedPrescriptionIndex + 1}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  DropdownButton<int>(
                    value: selectedPrescriptionIndex,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedPrescriptionIndex = newValue!;
                        selectedMedicineIndex = 0; // Reset medicine selection
                      });
                    },
                    items: List.generate(
                      prescriptionList.length,
                      (index) => DropdownMenuItem<int>(
                        value: index,
                        child: Text('Prescription ${index + 1}'),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  DropdownButton<int>(
                    value: selectedMedicineIndex,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedMedicineIndex = newValue!;
                      });
                    },
                    items: List.generate(
                      medicines.length,
                      (index) => DropdownMenuItem<int>(
                        value: index,
                        child: Text(medicines[index]['medicationName']),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < medicines.length) {
                            final medication = medicines[value.toInt()];
                            return Text(medication['medicationName']);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 15.0,
              animation: true,
              animationDuration: 1000,
              percent: selectedMedicineIndex == 0
                  ? overallAdherence
                  : calculateMedicineAdherence(
                      medicines[selectedMedicineIndex]),
              center: Text(
                "${((selectedMedicineIndex == 0 ? overallAdherence : calculateMedicineAdherence(medicines[selectedMedicineIndex])) * 100).toStringAsFixed(1)}%",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  double calculateMedicineAdherence(Map<String, dynamic> medicine) {
    final adherence = medicine['adherence'] ?? [];
    double medicineAdherence = 0.0;
    int totalAdherenceRecords = 0;

    for (final record in adherence) {
      if (record['morning']['taken'] &&
          record['afternoon']['taken'] &&
          record['night']['taken']) {
        medicineAdherence += 1.0;
      }
      totalAdherenceRecords++;
    }

    return medicineAdherence / totalAdherenceRecords;
  }
}

final List<Map<String, dynamic>> prescriptionList = [
  {
    "duration": "21 days",
    "patientid": "12345",
    "doctorLicenseNumber": "DOC123",
    "organization": "Health Clinic",
    "prescriptionDate": "2023-09-18",
    "vitalSigns": {
      "temperature": "98.6°F",
      "bloodPressure": "120/80 mmHg",
    },
    "diagnosis": "Respiratory Infection",
    "medicines": [
      {
        "medicationName": "Medicine A",
        "dosage": "1 tablet",
        "frequency": "3 times a day",
        "duration": "14 days",
        "beforeAfterFood": "After food",
        "refill": 2,
        "routeOfAdministration": "Oral",
        "typeOfMedicine": "Antibiotic",
        "quantity": 42,
        "adherence": [
          {
            "day": "2023-09-19",
            "morning": {
              "timestamp": "2023-09-19T08:00:00",
              "taken": true,
            },
            "afternoon": {
              "timestamp": "2023-09-19T13:00:00",
              "taken": false,
            },
            "night": {
              "timestamp": "2023-09-19T20:00:00",
              "taken": true,
            },
          },
          {
            "day": "2023-09-20",
            "morning": {
              "timestamp": "2023-09-20T08:15:00",
              "taken": true,
            },
            "afternoon": {
              "timestamp": "2023-09-20T12:45:00",
              "taken": true,
            },
            "night": {
              "timestamp": "2023-09-20T20:30:00",
              "taken": false,
            },
          },
          // Add more adherence records for "Medicine A" if needed
        ],
      },
      {
        "medicationName": "Medicine B",
        "dosage": "1 capsule",
        "frequency": "2 times a day",
        "duration": "10 days",
        "beforeAfterFood": "Before food",
        "refill": 1,
        "routeOfAdministration": "Oral",
        "typeOfMedicine": "Antipyretic",
        "quantity": 20,
        "adherence": [
          {
            "day": "2023-09-19",
            "morning": {
              "timestamp": "2023-09-19T08:30:00",
              "taken": true,
            },
            "afternoon": {
              "timestamp": "2023-09-19T14:00:00",
              "taken": true,
            },
            "night": {
              "timestamp": "2023-09-19T20:45:00",
              "taken": true,
            },
          },
          {
            "day": "2023-09-20",
            "morning": {
              "timestamp": "2023-09-20T08:00:00",
              "taken": true,
            },
            "afternoon": {
              "timestamp": "2023-09-20T13:30:00",
              "taken": true,
            },
            "night": {
              "timestamp": "2023-09-20T20:15:00",
              "taken": true,
            },
          },
          // Add more adherence records for "Medicine B" if needed
        ],
      },
      // You can add more medications to the prescription as required
    ],
  },
  {
    "duration": "30 days",
    "patientid": "56789",
    "doctorLicenseNumber": "DOC456",
    "organization": "Medical Center",
    "prescriptionDate": "2023-09-19",
    "vitalSigns": {
      "temperature": "99.0°F",
      "bloodPressure": "130/85 mmHg",
    },
    "diagnosis": "Hypertension",
    "medicines": [
      {
        "medicationName": "Medicine C",
        "dosage": "1 tablet",
        "frequency": "1 time a day",
        "duration": "30 days",
        "beforeAfterFood": "After food",
        "refill": 3,
        "routeOfAdministration": "Oral",
        "typeOfMedicine": "Antihypertensive",
        "quantity": 90,
        "adherence": [
          {
            "day": "2023-09-19",
            "morning": {
              "timestamp": "2023-09-19T09:00:00",
              "taken": true,
            },
          },
          {
            "day": "2023-09-20",
            "morning": {
              "timestamp": "2023-09-20T09:15:00",
              "taken": true,
            },
          },
          // Add more adherence records for "Medicine C" if needed
        ],
      },
    ],
  },
  {
    "duration": "14 days",
    "patientid": "98765",
    "doctorLicenseNumber": "DOC789",
    "organization": "Family Clinic",
    "prescriptionDate": "2023-09-20",
    "vitalSigns": {
      "temperature": "98.2°F",
      "bloodPressure": "120/75 mmHg",
    },
    "diagnosis": "Common Cold",
    "medicines": [
      {
        "medicationName": "Medicine D",
        "dosage": "1 tablet",
        "frequency": "2 times a day",
        "duration": "10 days",
        "beforeAfterFood": "After food",
        "refill": 2,
        "routeOfAdministration": "Oral",
        "typeOfMedicine": "Decongestant",
        "quantity": 20,
        "adherence": [
          {
            "day": "2023-09-20",
            "morning": {
              "timestamp": "2023-09-20T10:00:00",
              "taken": true,
            },
            "night": {
              "timestamp": "2023-09-20T20:00:00",
              "taken": true,
            },
          },
          // Add more adherence records for "Medicine D" if needed
        ],
      },
    ],
  },
  // You can add more prescriptions to the list as needed
];
