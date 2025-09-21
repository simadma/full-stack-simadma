variable "email" {
  type        = string
  description = "The email address used by Let's Encrypt for certificate issuance and expiration alerts."
}

variable "username" {
  type        = string
  description = "The username for accessing Traefik Dashboard."
}

variable "hashed_password" {
  type        = string
  description = "The hashed password for accessing Traefik Dashboard."
}

variable "domain" {
  type        = string
  description = "The domain name for the web app."
}
