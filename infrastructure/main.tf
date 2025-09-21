resource "digitalocean_domain" "domain" {
  name = var.domain
}

resource "digitalocean_droplet" "droplet" {
  image  = "ubuntu-24-04-x64"
  name   = digitalocean_domain.domain.name
  region = "ams3"
  size   = "s-1vcpu-1gb"
  user_data = templatefile("cloud-config.yaml.tftpl", {
    EMAIL           = var.email
    USERNAME        = var.username
    HASHED_PASSWORD = var.hashed_password
    DOMAIN          = var.domain
  })
  droplet_agent = false
}

resource "digitalocean_project" "project" {
  name        = "full-stack-simadma"
  description = "Full stack web app using FastAPI + Svelte + Tailwind CSS."
  purpose     = "Web Application"
  environment = "Production"
  resources = [
    digitalocean_droplet.droplet.urn,
    digitalocean_domain.domain.urn
  ]
}

resource "digitalocean_record" "root" {
  type   = "A"
  domain = digitalocean_domain.domain.id
  value  = digitalocean_droplet.droplet.ipv4_address
  name   = "@"
  ttl    = 1800
}

resource "digitalocean_record" "www" {
  type   = "CNAME"
  domain = digitalocean_domain.domain.id
  value  = "${digitalocean_domain.domain.name}."
  name   = "www"
  ttl    = 1800
}

resource "digitalocean_record" "api" {
  type   = "A"
  domain = digitalocean_domain.domain.id
  value  = digitalocean_droplet.droplet.ipv4_address
  name   = "api"
  ttl    = 1800
}

resource "digitalocean_record" "traefik" {
  type   = "A"
  domain = digitalocean_domain.domain.id
  value  = digitalocean_droplet.droplet.ipv4_address
  name   = "traefik"
  ttl    = 1800
}

resource "digitalocean_firewall" "fw" {
  name        = "${digitalocean_project.project.name}-fw-rules"
  droplet_ids = [digitalocean_droplet.droplet.id]
  inbound_rule {
    protocol         = "tcp"
    port_range       = 22
    source_addresses = ["0.0.0.0/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = 80
    source_addresses = ["0.0.0.0/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = 443
    source_addresses = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = 80
    destination_addresses = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol              = "tcp"
    port_range            = 443
    destination_addresses = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = 53
    destination_addresses = ["0.0.0.0/0"]
  }
}
