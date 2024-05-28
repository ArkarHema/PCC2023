const testPrescription = {
  duration: "21 days",
  patientid: "12345",
  doctorLicenseNumber: "DOC123",
  organization: "Health Clinic",
  prescriptionDate: new Date(),
  vitalSigns: {
    temperature: "98.6°F",
    bloodPressure: "120/80 mmHg",
  },
  diagnosis: "Respiratory Infection",
  medicines: [
    {
      medicationName: "Medicine A",
      dosage: "1 tablet",
      frequency: "3 times a day",
      duration: "14 days",
      beforeAfterFood: "After food",
      refill: 2,
      routeOfAdministration: "Oral",
      typeOfMedicine: "Antibiotic",
      quantity: 42,
      adherence: [
        {
          day: new Date("2023-09-19"),
          morning: {
            timestamp: new Date("2023-09-19T08:00:00"),
            taken: true,
          },
          afternoon: {
            timestamp: new Date("2023-09-19T13:00:00"),
            taken: false,
          },
          night: {
            timestamp: new Date("2023-09-19T20:00:00"),
            taken: true,
          },
        },
        {
          day: new Date("2023-09-20"),
          morning: {
            timestamp: new Date("2023-09-20T08:15:00"),
            taken: true,
          },
          afternoon: {
            timestamp: new Date("2023-09-20T12:45:00"),
            taken: true,
          },
          night: {
            timestamp: new Date("2023-09-20T20:30:00"),
            taken: false,
          },
        },
        // Add more adherence records for "Medicine A" if needed
      ],
    },
    {
      medicationName: "Medicine B",
      dosage: "1 capsule",
      frequency: "2 times a day",
      duration: "10 days",
      beforeAfterFood: "Before food",
      refill: 1,
      routeOfAdministration: "Oral",
      typeOfMedicine: "Antipyretic",
      quantity: 20,
      adherence: [
        {
          day: new Date("2023-09-19"),
          morning: {
            timestamp: new Date("2023-09-19T08:30:00"),
            taken: true,
          },
          afternoon: {
            timestamp: new Date("2023-09-19T14:00:00"),
            taken: true,
          },
          night: {
            timestamp: new Date("2023-09-19T20:45:00"),
            taken: true,
          },
        },
        {
          day: new Date("2023-09-20"),
          morning: {
            timestamp: new Date("2023-09-20T08:00:00"),
            taken: true,
          },
          afternoon: {
            timestamp: new Date("2023-09-20T13:30:00"),
            taken: true,
          },
          night: {
            timestamp: new Date("2023-09-20T20:15:00"),
            taken: true,
          },
        },
        // Add more adherence records for "Medicine B" if needed
      ],
    },
    // You can add more medications to the prescription as required
  ],
};

// Assuming you have a prescription object with adherence records
// You can pass the prescription object to this function to calculate adherence score

function calculatePrescriptionAdherence(prescription) {
  // Initialize variables to count total medications and total adherence scores
  let totalMedications = 0;
  let totalAdherenceScore = 0;

  // Loop through each medication in the prescription
  for (const medication of prescription.medicines) {
    // Calculate adherence scores for the medication using the previous function
    const adherenceScores = calculateAdherenceScoresForMedication(medication);

    // Calculate the average adherence score for the medication
    const averageMedicationAdherence =
      (parseFloat(adherenceScores.morning) +
        parseFloat(adherenceScores.afternoon) +
        parseFloat(adherenceScores.night)) /
      3;

    // Add the average adherence score to the total score
    totalAdherenceScore += averageMedicationAdherence;
    totalMedications++;
  }

  // Calculate the overall prescription adherence as the average of individual medication adherences
  const overallAdherence = totalAdherenceScore / totalMedications;

  return overallAdherence.toFixed(2);
}

// Example usage to calculate the overall prescription adherence
const overallAdherenceScore = calculatePrescriptionAdherence(testPrescription);

// Print the overall prescription adherence
console.log(`Overall Prescription Adherence: ${overallAdherenceScore}%`);

// Assuming you have a medication object with adherence records
// You can pass the medication object to this function to calculate adherence scores for each time of day

function calculateAdherenceScoresForMedication(medication) {
  // Initialize variables to count total doses and taken doses for each time of day
  let totalMorningDoses = 0;
  let takenMorningDoses = 0;
  let totalAfternoonDoses = 0;
  let takenAfternoonDoses = 0;
  let totalNightDoses = 0;
  let takenNightDoses = 0;

  // Loop through adherence records for the medication
  for (const adherenceRecord of medication.adherence) {
    // Check if medication was taken in the morning
    if (adherenceRecord.morning.taken) {
      takenMorningDoses++;
    }
    totalMorningDoses++;

    // Check if medication was taken in the afternoon
    if (adherenceRecord.afternoon.taken) {
      takenAfternoonDoses++;
    }
    totalAfternoonDoses++;

    // Check if medication was taken at night
    if (adherenceRecord.night.taken) {
      takenNightDoses++;
    }
    totalNightDoses++;
  }

  // Calculate adherence scores for each time of day as percentages
  const morningAdherenceScore = (takenMorningDoses / totalMorningDoses) * 100;
  const afternoonAdherenceScore =
    (takenAfternoonDoses / totalAfternoonDoses) * 100;
  const nightAdherenceScore = (takenNightDoses / totalNightDoses) * 100;

  return {
    morning: morningAdherenceScore.toFixed(2),
    afternoon: afternoonAdherenceScore.toFixed(2),
    night: nightAdherenceScore.toFixed(2),
  };
}

// Example usage to calculate adherence scores for "Medicine A"
const medication = testPrescription.medicines[0];
const adherenceScores = calculateAdherenceScoresForMedication(medication);

// Print the adherence scores for "Medicine A"
console.log(`Morning Adherence Score: ${adherenceScores.morning}%`);
console.log(`Afternoon Adherence Score: ${adherenceScores.afternoon}%`);
console.log(`Night Adherence Score: ${adherenceScores.night}%`);
