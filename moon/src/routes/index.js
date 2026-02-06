import express from "express";
import logger from "#logger";

const router = express.Router();

router.get("/", (_, res) => {
  logger.info("test");
  res.sendStatus(200);
});

router.post("/immich/upgrade", (req, res) => {
  logger.info("immich auto update");
  res.sendStatus(200);
});

export default router;
