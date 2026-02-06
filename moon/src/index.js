import "./services/vpn.js";

import http from "http";
import express from "express";
import routes from "./routes/index.js";
import ddns from "./services/ddns.js";
import logger from "#logger";

const port = process.env.PORT || 6705;
const app = express();
const server = http.createServer(app);

ddns();

app.use("/", routes);

server.listen(port, () => {
  logger.info(`http server listening on port ${port}`);
});
