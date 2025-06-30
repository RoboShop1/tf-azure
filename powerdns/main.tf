provider "powerdns" {
  api_key    = "supersecretapikey"
  server_url = "http://172.31.23.218:8081"
}


resource "powerdns_record" "foobar" {
  zone    = "spark.in."
  name    = "www.spark.in."
  type    = "A"
  ttl     = 300
  records = ["192.168.0.11"]
}