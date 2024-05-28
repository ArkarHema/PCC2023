// src/routes/patientRoutes.js
const express = require("express");
const router = express.Router();
const patientController = require("../controllers/paitentController");
const prescriptionController = require("../controllers/prescriptionController");

// Create a new patient
router.post("/register", patientController.createPatient);

// Get a list of all patients
router.get("/", patientController.getAllPatients);

// Get patient details by ID
router.get("/:patientId", patientController.getPatientById);

// Get Prescriptions based on Patient Id
router.get(
  "/prescriptions/:patientId",
  prescriptionController.getPrescriptionsForPatient
);

// Update patient information by ID
router.put("/update/:patientId", patientController.updatePatient);

// Login using User credentials
router.post("/login", patientController.login);

router.post("/verify-OTP", patientController.verifyOtp);

router.put(
  "/update/preferedTimings/:patientId",
  patientController.updatePreferedTime
);

module.exports = router;
