var mc = require("mcprotocol");
var conn = new mc();

const connection = require("./config/database");

var variables = {
  X0_INPUT: "X0,16",
  START_INPUT: "X2",
  RESET_INPUT: "X5",
  RETURN_INPUT: "X6",
  MEMORY_BLACK: "D1",
  MEMORY_WHITE: "D2",
};
var variablesRead = {
  X0_INPUT: "X0,16",
};
var doneReading = false;
var doneWriting = false;
var plcConnected = false;

connection(
  conn.initiateConnection(
    { port: 10000, host: "192.168.3.39", ascii: false },
    connected
  )
);

function connected(err) {
  if (typeof err !== "undefined") {
    // We have an error.  Maybe the PLC is not reachable.
    console.log(err);
    // process.exit();
  } else {
    plcConnected = true;
    conn.setTranslationCB(function (tag) {
      return variables[tag];
    });
    conn.addItems(Object.keys(variablesRead));
    setInterval(() => {
      if (doneWriting) conn.readAllItems(valuesReady);
    }, 100);
  }
}
const express = require("express");
const app = express();
const port = 8000;
app.use(express.json());
app.listen(port, () => {
  console.log(`Server is running on ${port}`);
});
app.post("/control", (req, res) => {
  try {
    if (plcConnected) {
      doneWriting = false;
      const { body } = req;

      // conn.writeItems(Object.keys(body), Object.values(body), (anythingBad) => {
      //   valuesWritten(anythingBad, res);
      // });
      // conn.writeItems([body.key], [body.value], (anythingBad) => {
      //   valuesWritten(anythingBad, res);
      // });
    } else {
      res.status(500).send({
        status: "error",
        message: "PLC NOT CONNECTED",
      });
    }
  } catch (error) {
    res.status(500).send({
      status: "error",
      message: error.toString(),
    });
  }
});

function valuesWritten(anythingBad, res) {
  try {
    if (anythingBad) {
      console.log("SOMETHING WENT WRONG WRITING VALUES!!!!");
      res.status(500).send({
        status: "error",
        message: "SOMETHING WENT WRONG WRITING VALUES!!!!",
        data: doneWriting,
      });
    }
    console.log("Done writing.");
    doneWriting = true;
    res.status(200).send({
      status: "ok",
      message: "done",
      data: doneWriting,
    });
    // if (doneReading) {
    //   process.exit();
    // }
  } catch (error) {
    console.log(error);
  }
}

const DistributionStation = require("./model/DistributionStation");
const BottleCounting = require("./model/BottleCounting");
const Monitoring = require("./model/Monitoring");
const { convertNumberToAlphabet, checkForChanges } = require("./utils");

let lastVariableValues = {};
async function valuesReady(anythingBad, values) {
  if (anythingBad) {
    console.log("SOMETHING WENT WRONG READING VALUES!!!!");
  }
  const x_input = {};
  values.X0_INPUT.forEach((value, index) => {
    const key = `${convertNumberToAlphabet(index)}`; // Generating key names like X0_0, X0_1, ...
    x_input[key] = value; // Assigning values to keys
  });
  values = {
    ...values,
    ...x_input,
  };
  delete values.X0_INPUT;

  if (checkForChanges(lastVariableValues, values)) {
    console.log(new Date(), values);
    let color = "";
    if (!values.S_A0) {
      color = "white";
    }
    if (!values.S_B0) {
      color = "black";
    }
    await new BottleCounting({
      color: color,
    }).save();
    await new DistributionStation(values).save();
    await Monitoring.findOneAndUpdate(
      {
        station: "distribution",
      },
      {
        station: "distribution",
        data: values,
        updated_at: Date.now(),
      },
      { upsert: true, new: true, runValidators: true }
    );
    lastVariableValues = values;
  } else {
    lastVariableValues = values;
  }
  doneReading = true;
  // if (doneWriting) {
  //   process.exit();
  // }
}
