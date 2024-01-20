var mongoose = require("mongoose");
const connection = async (callback) => {
  mongoose.set("debug", false);

  mongoose.connect(
    `mongodb://127.0.0.1:27018,127.0.0.1:27019/polman-mes-monitoring?replicaSet=plmn`,
    // `mongodb://127.0.0.1:27019/polman-mes-monitoring`,
    // `mongodb://127.0.0.1:27017/polman-mes-monitoring`,
    {
      //   connectWithNoPrimary: true,
      //   keepAlive: true,
      //   useNewUrlParser: true,
      //   useUnifiedTopology: true,
      //   socketTimeoutMS: 60000,
      //   replicaSet: "plmn",
    }
  ),
    () => {
      console.log("Database Connection Success");
    };

  let db = mongoose.connection;
  db.on("error", console.error.bind(console, "Database Connection Error"));
  db.once("open", async () => {
    console.log("Database is connected");
    callback;
  });
};
module.exports = connection;
