const Patient = require("../models/patient");
const sendOTP = require("../utils/aws/pinpoint/sendOtp");
// Create a new patient
exports.createPatient = async (req, res) => {
  try {
    const {
      fullName,
      dateOfBirth,
      gender,
      contactNumber,
      email,
      bloodGroup,
      address,
    } = req.body;

    const patient = new Patient({
      fullName,
      dateOfBirth,
      gender,
      contactNumber,
      email,
      bloodGroup,
      address,
    });

    await patient.save();

    res.status(201).json(patient);
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while creating the patient");
  }
};

// Get a list of all patients
exports.getAllPatients = async (req, res) => {
  try {
    const patients = await Patient.find();

    res.json(patients);
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching patients");
  }
};

// Get patient details by ID
exports.getPatientById = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.patientId);

    if (!patient) {
      return res.status(404).send("Patient not found");
    }

    res.json(patient);
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching patient details");
  }
};

// Update patient information by ID
exports.updatePatient = async (req, res) => {
  try {
    const {
      fullName,
      dateOfBirth,
      gender,
      contactNumber,
      email,
      bloodGroup,
      address,
    } = req.body;

    const updatedPatient = await Patient.findByIdAndUpdate(
      req.params.patientId,
      {
        fullName,
        dateOfBirth,
        gender,
        contactNumber,
        email,
        bloodGroup,
        address,
      },
      { new: true } // Return the updated document
    );

    if (!updatedPatient) {
      return res.status(404).send("Patient not found");
    }

    res.json(updatedPatient);
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .send("An error occurred while updating patient information");
  }
};

exports.updatePreferedTime = async (req, res) => {
  try {
    const preferedTiminings = req.body.perferedTimings; // Extract preferedTiminings from the request body

    // Find the patient by ID and update the preferred timings
    const updatedPatient = await Patient.findByIdAndUpdate(
      req.params.patientId,
      { preferedTiminings: preferedTiminings },
      { new: true }
    );

    if (!updatedPatient) {
      return res.status(404).send("Patient not found");
    }

    res.status(201).json(updatedPatient);
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .send("An error occurred while updating patient information");
  }
};

const otpStorage = new Map(); // A temporary storage for OTPs

// Login
exports.login = async (req, res) => {
  try {
    const { name, phone_number } = req.body;
    const patient = await Patient.findOne({ contactNumber: phone_number });

    if (!patient) {
      return res.status(404).send("Patient not found");
    }

    if (patient.fullName !== name) {
      return res.status(404).send("Patient not found");
    }

    res.status(201).json(patient._id);
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching patient details");
  }
};

exports.verifyOtp = (req, res) => {
  try {
    const { phone_number, userOTP } = req.body;

    const storedOTP = otpStorage.get(phone_number);

    if (!storedOTP) {
      return res.status(401).json({ message: "OTP not found" });
    }

    if (userOTP === storedOTP.otp) {
      // OTP is valid
      otpStorage.delete(phone_number); // Remove the OTP from storage after successful verification
      res.status(200).json({ message: "OTP verification successful" });
    } else {
      // Invalid OTP
      res.status(401).json({ message: "Invalid OTP" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while verifying OTP");
  }
};
