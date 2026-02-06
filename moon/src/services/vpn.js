import { execSync } from "child_process";
import { CronJob } from "cron";
import env from "#env";
import logger from "#logger";

if (env.vpnRefresh) {
  logger.info("vpn will be refreshed every 8 hours");
  CronJob.from({
    cronTime: "0 */8 * * *", // every 8 hours
    onTick: () => {
      const c = `sudo systemctl restart wg-quick@polarbear`;
      execSync(c, { stdio: "inherit" });
    },
    start: true,
    runOnInit: true,
  });
}
