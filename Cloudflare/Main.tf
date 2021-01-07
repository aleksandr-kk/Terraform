
terraform {
  backend "local" {
    path = "c:\\Scripts\\TF\\Cloudflare\\terraform.tfstate"
  }
}

provider "cloudflare" {
  version = "~> 2.0"
  email      = "<emailaddress>"
  api_key    = "<apikey>"
  account_id = "<account id>"
}


#############################################################################
# drezadm4rdex.com
#############################################################################
data "cloudflare_zones" "domain" {
  filter {
    name = "drezadm4rdex.com"
  }
}

resource "cloudflare_record" "autodiscover" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = "_autodiscover._tcp"
  type    = "SRV"
  ttl     = 300

data = {
    service  = "_autodiscover"
    proto    = "_tcp"
    name     = "terraform-srv"
    priority = 1
    weight   = 1
    port     = 443
    target   = "mail.systems.online"
  }
}

resource "cloudflare_record" "spf" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = "@"
  type    = "TXT"
  ttl     = 300
  value = "v=spf1 mx a:mx.mxmailscan.com include:spf.mxmailscan.com -all"
}

resource "cloudflare_record" "mx01" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = "@"
  type    = "MX"
  ttl     = 300
  value = "mx1.mailscan.com"
  priority = 10
}

resource "cloudflare_record" "mx02" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  name    = "@"
  type    = "MX"
  ttl     = 300
  value = "mx2.mailscan.com"
  priority = 20
}


#############################################################################
# advessrtisidnseniasus.net
#############################################################################
data "cloudflare_zones" "domain2" {
  filter {
    name = "advessrtisidnseniasus.net"
  }
}


resource "cloudflare_record" "dkim2" {
  zone_id = lookup(data.cloudflare_zones.domain2.zones[0], "id")
  name    = "eeab08ba._domainkey"
  type    = "TXT"
  ttl     = 300
  value = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDaY7p0SLafPGDbUnST7rMAvPiNhhbIN/nnYWLRMfKndYSskzAmbpKq6PNCH+mu726jZHx15r4VMXLeLfEwa94Nln3aGUFku2qVmsRqJDROcI7uJaJXOseSLCK6zD1SaZZCW9jhZ9h0+fGWKsypuZ+MnBl9nl5sxjc8E/5qAc2PwQIDAQAB"
}



