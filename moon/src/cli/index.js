#!/usr/bin/env node
import { execSync } from "child_process";
import os from "os";

function getSite() {
  if (process.argv[1].includes("penguin")) return "au";
  if (process.argv[1].includes("polarbear")) return "tw";
}

const site = getSite();
const command = process.argv[2];

const homedir = os.homedir();
const dockerDir = homedir + "/homelab/docker";

switch (command) {
  case "update": {
    const c = `docker compose -f ${site}.yaml pull && docker compose -f ${site}.yaml up -d && docker image prune -f`;
    execSync(c, { cwd: dockerDir, stdio: "inherit" });
    break;
  }
  case "up": {
    const c = `docker compose -f ${site}.yaml up -d`;
    execSync(c, { cwd: dockerDir, stdio: "inherit" });
    break;
  }
}
