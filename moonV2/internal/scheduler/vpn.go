package scheduler

import (
	"moon-v2/internal/log"
	"os/exec"
)

func RestartVPN() {
	cmd := exec.Command("sudo", "systemctl", "restart", "wg-quick@polarbear")
	err := cmd.Run()
	if err != nil {
		log.Error(err.Error())
	}
}
