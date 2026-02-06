import { execSync } from "child_process";
import axios from "axios";
import { CronJob } from "cron";
import env from "#env";
import logger from "#logger";

let publicIP;
const instance = axios.create({
  baseURL: `https://api.cloudflare.com/client/v4/zones/${env.zoneId}`,
  headers: {
    Authorization: `Bearer ${env.apiToken}`,
  },
});

const dnsRecords = await fetchDNSRecords();

function getPublicIP() {
  return execSync("curl ifconfig.me", { stdio: "pipe" }).toString();
}

function updateDNSRecords() {
  const newIP = getPublicIP();
  if (publicIP === newIP) return;

  logger.info(`ddns: public IP has been changed from ${publicIP} to ${newIP}`);

  return dnsRecords.map((r) =>
    instance
      .put(`/dns_records/${r.id}`, {
        content: newIP,
        name: r.name,
        type: r.type,
        comment: `Last updated: ${new Date().toLocaleString()}`,
      })
      .then(() => {
        logger.info(`ddns: successfully updated ${r.name} -> ${newIP}`);
        publicIP = newIP;
      })
      .catch(logger.error),
  );
}

async function fetchDNSRecords() {
  try {
    const res = await instance.get("/dns_records");
    const list = res.data.result
      .map((r) => ({
        id: r.id,
        content: r.content,
        name: r.name,
        type: r.type,
      }))
      .filter((r) => env.dnsUpdateList.includes(r.name));

    publicIP = list[0].content;
    logger.info(`ddns: DNS records are set to ${publicIP}`);
    return list;
  } catch (err) {
    logger.error(err);
  }
}

function start() {
  CronJob.from({
    cronTime: "*/5 * * * *", // every 5 mins
    onTick: updateDNSRecords,
    start: true,
    runOnInit: true,
  });
}

export default start;
