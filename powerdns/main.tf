terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
  }
}

provider "powerdns" {
  api_key    = "supersecretapikey"
  server_url = "http://172.31.23.218:8081/api/v1"  # Added /api/v1
}

resource "powerdns_record" "www" {
  zone    = "spark.in."
  name    = "www.spark.in."
  type    = "A"
  ttl     = 300
  records = ["192.168.0.11"]
}