//go:build dev

package config

import "os"

var ZoneID = "xxx"
var CfToken = "Bearer xxx"
var DnsUpdateList = []string{}

func init() {
	os.Setenv("TZ", "UTC")
}
