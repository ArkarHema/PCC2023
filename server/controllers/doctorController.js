const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const Doctor = require("../models/doctor");

const JWT_SECRET = process.env.JWT_SECRET;

const saltRounds = 10;

exports.register = async (req, res) => {
  try {
    const { fullName, licenseNumber, email, organization, password } = req.body;

    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const doctor = new Doctor({
      fullName,
      licenseNumber,
      email,
      organization,
      password: hashedPassword,
    });

    await doctor.save();

    res.status(201).send("Doctor registered successfully");
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while registering the doctor");
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const doctor = await Doctor.findOne({ email });

    if (!doctor) {
      return res.status(404).send("Doctor not found");
    }

    const passwordMatch = await bcrypt.compare(password, doctor.password);

    if (!passwordMatch) {
      return res.status(401).send("Invalid password");
    }

    const token = jwt.sign(
      {
        _id: doctor._id,
        fullName: doctor.fullName,
        licenseNumber: doctor.licenseNumber,
        email: doctor.email,
        organization: doctor.organization,
      },
      JWT_SECRET
    );

    res.json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while logging in");
  }
};

exports.update = async (req, res) => {
  try {
    const { fullName, licenseNumber, email, organization, password } = req.body;
    const doctorId = req.params.doctorId; // Assuming you pass the doctorId in the URL

    // Check if the doctor with the specified ID exists
    const doctor = await Doctor.findById(doctorId);

    if (!doctor) {
      return res.status(404).send("Doctor not found");
    }

    // Update the doctor's profile fields
    doctor.fullName = fullName;
    doctor.licenseNumber = licenseNumber;
    doctor.email = email;
    doctor.organization = organization;

    if (password) {
      // If a new password is provided, hash and update the password
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      doctor.password = hashedPassword;
    }

    // Save the updated doctor profile
    await doctor.save();

    res.status(200).send("Doctor profile updated successfully");
  } catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while updating the doctor profile");
  }
};
