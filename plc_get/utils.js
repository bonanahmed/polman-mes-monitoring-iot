// Function to check for changes in object properties
function checkForChanges(previous, current) {
  for (const key in current) {
    if (current.hasOwnProperty(key) && current[key] !== previous[key]) {
      return true; // Return true if any property value has changed
    }
  }

  return false; // Return false if no property value has changed
}
function convertNumberToAlphabet(number) {
  switch (number) {
    case 0:
      return "AUTO";
    case 1:
      return "MANUAL";
    case 2:
      return "START";
    case 3:
      return "OPTIC_2";
    case 4:
      return "EMERGENCY";
    case 5:
      return "RESET";
    case 6:
      return "RETURN";
    case 7:
      return "PROXIMITY_1"; //INPUT_1
    case 8:
      return "PROXIMITY_2"; //INPUT_2
    case 9:
      return "S_A0";
    case 10:
      return "S_A1";
    case 11:
      return "S_B0";
    case 12:
      return "S_B1";
    case 13:
      return "S_RGB1";
    case 14:
      return "S_RGB2";
    case 15:
      return "OPTIC_1";
    default:
      return "X" + number;
  }
}

module.exports = {
  checkForChanges,
  convertNumberToAlphabet,
};
