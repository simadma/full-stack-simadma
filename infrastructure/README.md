# Infrastructure

This directory contains the infrastructure configuration for our full-stack web
application hosted on **DigitalOcean**. Terraform is used to manage and
provision resources, with state files hosted on
[HashiCorp Cloud Platform](https://app.terraform.io/).

---

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed
- [DigitalOcean personal access token](https://docs.digitalocean.com/reference/api/create-personal-access-token/)
- (Optional)
[DigitalOcean CLI (`doctl`)](https://docs.digitalocean.com/reference/doctl/) for
easier token management
- Access to the HashiCorp Cloud Platform workspace where our state files are
stored

---

## Usage

### 1. Authenticate

First, we log in to Terraform:

```bash
terraform login
````

Next, we provide our DigitalOcean API token. If we have `doctl` installed, we
can automatically set it:

```bash
export DIGITALOCEAN_TOKEN=$(doctl auth token)
```

Alternatively, we can manually export the token:

```bash
export DIGITALOCEAN_TOKEN=<your_personal_access_token>
```

---

### 2. Initialize Terraform

We initialize the Terraform working directory:

```bash
terraform init
```

---

### 3. Set Terraform Variables

We need to set the following variables:

1. **Email** – used for Let's Encrypt certificate issuance

```bash
export TF_VAR_email=<email_address_for_lets_encrypt_certificate_issuance>
```

2. **Domain** – the domain name for our application

```bash
export TF_VAR_domain=<your_domain_here.com>
```

3. **Username** – for Basic Auth to access the Traefik dashboard

```bash
export TF_VAR_username=<username>
```

4. **Hashed password** – we will be prompted to create a password. Remember this
password, or write it down somewhere safe. A hashed password will be generated
automatically using bcrypt:

```bash
export TF_VAR_hashed_password=$(htpasswd -Bn "${TF_VAR_username}" | cut -d ':' -f2)
```

> **Note:** Make sure `htpasswd` is installed for password hashing.

---

### 4. Provision Infrastructure

Finally, we create the resources defined in Terraform:

```bash
terraform apply
```

We type `yes` when prompted to confirm.

This will provision the web server and all required infrastructure on
DigitalOcean.
