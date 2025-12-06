package main

import (
	"moon-v2/internal/config"
	"moon-v2/internal/scheduler"

	"github.com/robfig/cron/v3"
)

func main() {
	c := cron.New()
	c.Start()
	defer c.Stop()

	if len(config.DnsUpdateList) > 0 {
		scheduler.DDNSInit()
		c.AddFunc("*/5 * * * *", scheduler.DDNS) // every 5 mins on the dot
	}

	select {}
}
