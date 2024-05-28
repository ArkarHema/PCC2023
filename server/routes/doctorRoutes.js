// src/routes/doctorRoutes.js
const express = require("express");
const router = express.Router();
const doctorController = require("../controllers/doctorController");
const prescriptionController = require("../controllers/prescriptionController");

// Doctor registration
router.post("/register", doctorController.register);

// Doctor login
router.post("/login", doctorController.login);

// Doctor Update
router.put("/update/:doctorId", doctorController.update);

router.post("/createPrescriptions", prescriptionController.createPrescriptions);

module.exports = router;
