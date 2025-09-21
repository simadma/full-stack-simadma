terraform {
  cloud {
    organization = "simadma"
    workspaces {
      name = "full-stack-simadma"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">=2.67.0,<3"
    }
  }
}
