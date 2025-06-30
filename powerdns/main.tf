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
  server_url = "http://localhost:8081"
}

resource "powerdns_record" "www" {
  zone    = "spark.in."
  name    = "chaitu.spark.in."
  type    = "A"
  ttl     = 300
  records = ["192.168.0.11"]
}