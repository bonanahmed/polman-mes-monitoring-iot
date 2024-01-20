const Monitoring = require("./model/Monitoring");

const emmitterMonitoring = (io, data) => {
  const param = "distribution:update";
  console.log("on data changed, socket io will emitting", param);
  io.emit(param, data);
};
const runWatch = async (io) => {
  // Create a change stream. The 'change' event gets emitted when there's a
  // change in the database
  Monitoring.watch().on("change", (data) => {
    console.log(new Date(), "Data Change", data);
    emmitterMonitoring(io, data.updateDescription.updatedFields.data); // after data changed, will execute function for emitting socket io
  });
};

module.exports = {
  watch: runWatch,
};
