import "./secret.js";

export default {
  zoneId: process.env.ZONE_ID,
  apiToken: process.env.API_TOKEN,
  dnsUpdateList: process.env.DNS_UPDATE_LIST,
  vpnRefresh: process.env.ENABLE_VPN_REFRESH,
};
