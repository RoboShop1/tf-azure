terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
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
  records = ["192.168.0.15"]
}

resource "null_resource" "run" {
  depends_on = [powerdns_record.www]

  triggers = {
    # Triggers when any of these change:
    record_id  = "${powerdns_record.www.zone}:${powerdns_record.www.name}:${powerdns_record.www.type}"
    record_content = join(",", powerdns_record.www.records)  # Sensitive to IP changes
    record_ttl = powerdns_record.www.ttl
  }

  provisioner "local-exec" {
    command =<<EOT
pdnsutil increase-serial spark.in
pdns_control notify spark.in
EOT
  }
  }