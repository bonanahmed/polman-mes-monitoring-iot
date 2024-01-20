// userModel.js

const mongoose = require("mongoose");

// Define the schema
const distributionSchema = new mongoose.Schema({
  AUTO: Boolean,
  MANUAL: Boolean,
  START: Boolean,
  OPTIC_2: Boolean,
  EMERGENCY: Boolean,
  RESET: Boolean,
  RETURN: Boolean,
  PROXIMITY_1: Boolean,
  PROXIMITY_2: Boolean,
  S_A0: Boolean,
  S_A1: Boolean,
  S_B0: Boolean,
  S_B1: Boolean,
  S_RGB1: Boolean,
  S_RGB2: Boolean,
  OPTIC_1: Boolean,
  created_at: {
    type: Date,
    required: true,
    default: Date.now,
  },
  updated_at: {
    type: Date,
    required: true,
    default: Date.now,
  },
});

// Create and export the model based on the schema
module.exports = mongoose.model("Distribution", distributionSchema);
