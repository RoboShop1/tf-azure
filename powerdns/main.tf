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
  server_url = "http://172.31.23.218:8081"
}