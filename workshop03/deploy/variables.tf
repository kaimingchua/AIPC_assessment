variable DO_token {
    type = string 
    sensitive = true
}
variable DO_private_key {
  type = string
  sensitive = true
}
variable DO_image {
    type = string
    default = "ubuntu-20-04-x64"
}
variable DO_region {
    type = string
    default = "sgp1"
}
variable DO_size {
    type = string
    default = "s-1vcpu-2gb"
}

variable CF_email {
  type = string
}
variable CF_api_token {
  type = string
  sensitive = true
}

variable CS_code_server {
  type = string
  default = "codeserver"
}
variable CS_password {
  type = string
}
variable CS_version {
  type = string
}

