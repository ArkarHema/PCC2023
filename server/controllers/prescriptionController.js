const Prescription = require("../models/prescription");
const Patient = require("../models/patient");
const { handleNotification } = require("../firebase.config");

// Define a route or controller function to create a prescription
exports.createPrescriptions = async (req, res) => {
  try {
    // Extract prescription data from the request
    const {
      duration,
      patientId, // Assuming you have the patient's ID
      doctorLicenseNumber,
      organization,
      vitalSigns,
      diagnosis,
      medicines, // An array of medication data
    } = req.body;

    // Create a new prescription document
    const prescription = new Prescription({
      duration,
      patientid: patientId,
      doctorLicenseNumber,
      organization,
      vitalSigns,
      diagnosis,
      medicines,
    });

    // Save the prescription to the database
    await prescription.save();

    // Update the patient's activePrescriptions array with the new prescription's ID
    const patient = await Patient.findById(patientId);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    patient.activePrescriptions.push(prescription._id);
    await patient.save();

    await handleNotification(
      "Doctor Prescribed",
      "You have a new prescription",
      "dIfzw_rMT8-ZvcXZ7okvmz:APA91bE_O3CZaW-_mZ8K67XCif43mPLx3_3bA9zut4Vc9P2rrrkSBFKV2_Zjs1A3LR52EKR4lgTshJaG9UWsRdcPRMPRZ1l7rrpZ_plpSNNL4VIF1K_MUL43SGsGrOY57QXd8lbmGhru"
    );

    return res.status(201).json({
      message: "Prescription created and associated with the patient",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

// Get prescriptions for a specific patient by patient ID
exports.getPrescriptionsForPatient = async (req, res) => {
  try {
    const patientId = req.params.patientId; // Extract patient ID from request parameters

    // Find the patient by ID
    const patient = await Patient.findById(patientId).populate(
      "activePrescriptions"
    );

    if (!patient) {
      return res.status(404).send("Patient not found");
    }

    // Access the prescriptions for the patient
    const prescriptions = patient.activePrescriptions;

    res.json(prescriptions);
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching prescriptions");
  }
};
