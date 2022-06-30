terraform {
  required_version = "> 1.2"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    hashicorp = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "3.18.0"
    }
  }
}

provider cloudflare {
  email = var.CF_email
  api_token = var.CF_api_token
}

provider digitalocean {
  token = var.DO_token
}

provider hashicorp { }
