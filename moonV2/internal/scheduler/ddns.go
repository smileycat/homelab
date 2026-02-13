package scheduler

import (
	"bytes"
	"encoding/json"
	"moon-v2/internal/config"
	"moon-v2/internal/http"
	"moon-v2/internal/log"
	"slices"
	"time"
)

type DNSRecord struct {
	ID      string `json:"id"`
	Name    string `json:"name"`    // i.e. www.smileyfam.me
	Content string `json:"content"` // ip address
	Type    string `json:"type"`    // i.e. "A" record
	Comment string `json:"comment"`
}

type ApiResponse struct {
	Result []DNSRecord `json:"result"`
}

var httpClient http.Client
var dnsRecords []DNSRecord
var publicIP string

func updateDNSRecord(r *DNSRecord) {
	oldIP := r.Content
	r.Content = publicIP
	r.Comment = "Last updated: " + time.Now().Format("2006-01-02 15:04:05 MST")
	jsonBody, _ := json.Marshal(r)
	httpClient.Put("/dns_records/"+r.ID, bytes.NewBuffer(jsonBody))

	log.Info("ddns: successfully updated %v from %v -> %v", r.Name, oldIP, publicIP)
}

func fetchDNSRecords() {
	body := httpClient.Get("/dns_records", nil)

	var jsonBody ApiResponse
	json.Unmarshal(body, &jsonBody)

	for _, item := range jsonBody.Result {
		if slices.Contains(config.DnsUpdateList, item.Name) {
			dnsRecords = append(dnsRecords, item)
			if item.Content != publicIP {
				updateDNSRecord(&item)
			}
		}
	}

	log.Info("dns %v", dnsRecords)
}

func getPublicIP() string {
	body := http.Client{}.Get(config.IPv4GetterURL, nil)
	return string(body)
}

func DDNS() {
	newIP := getPublicIP()
	if newIP == "" || publicIP == newIP {
		return
	}

	log.Info(`ddns: public IP has been changed from %v to %v`, publicIP, newIP)
	publicIP = newIP

	for _, r := range dnsRecords {
		go updateDNSRecord(&r)
	}
}

func DDNSInit() {
	httpClient = http.Client{
		BaseURL: "https://api.cloudflare.com/client/v4/zones/" + config.ZoneID,
		Header:  http.Header{Authorization: config.CfToken},
	}

	publicIP = getPublicIP()
	log.Info("ddns: public IP is %v", publicIP)
	fetchDNSRecords()
	DDNS()
}
