import { execSync } from "child_process";

let job = null;

function tryLock(newJob) {
  if (job) {
    throw new Error(`immich: ${job} is in progress, please try again later`);
  }
  job = newJob;
}

function unlock() {
  job = null;
}

function backup() {
  tryLock("backup");
  execSync("bash /scripts/immich_backup.sh");
  unlock();
}

function upgrade() {
  tryLock("upgrade");
  unlock();
}

export default { backup, upgrade };
