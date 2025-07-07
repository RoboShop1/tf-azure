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
  name    = "chaitu1.spark.in."
  type    = "A"
  ttl     = 300
  records = ["192.168.0.15"]
}

resource "null_resource" "run" {
  depends_on = [powerdns_record.www]

  triggers = {
    record_id  = "${powerdns_record.www.zone}:${powerdns_record.www.name}:${powerdns_record.www.type}"
    record_content = join(",", powerdns_record.www.records)
    record_ttl = powerdns_record.www.ttl
  }

  provisioner "local-exec" {
    command =<<EOT
pdnsutil increase-serial spark.in
pdns_control notify spark.in
EOT
  }
  }







CHANGE MASTER TO
MASTER_HOST='172.31.18.42',
MASTER_USER='repluser',
MASTER_PASSWORD='YourNewSecurePassword123!',
MASTER_LOG_FILE='mysql-bin.000001',
MASTER_LOG_POS=1234;





MariaDB [(none)]> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      328 | powerdns     |                  |
+------------------+----------+--------------+------------------+



SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      328 | powerdns     |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.000 sec)


CHANGE MASTER TO
MASTER_HOST='172.31.27.227',
MASTER_USER='repluser',
MASTER_PASSWORD='Onetwo@123',
MASTER_LOG_FILE='mysql-bin.000001',
MASTER_LOG_POS=328;






CHANGE MASTER TO
MASTER_HOST='172.31.25.64',
MASTER_USER='repluser',
MASTER_PASSWORD='Onetwo@123',
MASTER_LOG_FILE='mysql-bin.000001',
MASTER_LOG_POS=328;























CHANGE MASTER TO
MASTER_HOST='172.31.27.75',
MASTER_USER='repluser',
MASTER_PASSWORD='One@123',
MASTER_LOG_FILE='mysql-bin.000001',
MASTER_LOG_POS=328;








CHANGE MASTER TO
MASTER_HOST='172.31.31.59',
MASTER_USER='repluser',
MASTER_PASSWORD='One@123',
MASTER_LOG_FILE='mysql-bin.000001',
MASTER_LOG_POS=328;



