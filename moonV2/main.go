package main

import (
	"moon-v2/internal/log"
	"moon-v2/internal/scheduler"
	"os"
	"strconv"

	"github.com/robfig/cron/v3"
)

/* ENV VARIABLES:
 * TZ
 * CF_TOKEN
 * ZONE_ID
 * DNS_UPDATE_LIST
 * ENABLE_VPN_REFRESH
 */

func main() {
	c := cron.New()
	vpn, _ := strconv.ParseBool(os.Getenv("ENABLE_VPN_REFRESH"))

	if vpn {
		log.Info("VPN restarter is scheduled every 6h!")
		scheduler.RestartVPN()
		c.AddFunc("0 */6 * * *", scheduler.RestartVPN) // every 6 hours on the clock
	}

	c.Start()
	defer c.Stop()

	if os.Getenv("DNS_UPDATE_LIST") != "" {
		scheduler.DDNSInit()
		c.AddFunc("*/5 * * * *", scheduler.DDNS) // every 5 mins on the dot
	}

	select {}
}
