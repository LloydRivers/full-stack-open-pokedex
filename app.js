const express = require("express");
const app = express();
let counter = 0;
// Heroku dynamically sets a port
const PORT = process.env.PORT || 5000;

app.use(express.static("dist"));

app.get("/health", (req, res) => {
  if (res.statusCode !== 200) {
    res.status(500).send("error");
  } else {
    res.status(200).send();
  }
});

app.get('/version', (req, res) => {
  res.send('1') // change this string to ensure a new version deployed
})

app.listen(PORT, () => {
  /* eslint-disable no-console */
  console.log("server started on port 5000");
  /* eslint-disable no-console */
});
