data "http" "ip_check" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  my_ip = "${chomp(data.http.ip_check.body)}/32"
}