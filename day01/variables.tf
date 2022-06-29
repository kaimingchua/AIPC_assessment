variable "DO_token" {
  type      = string
  sensitive = true
  default   = "dop_v1_3ae7fa3a18a67a2886cacb22fc7e7bd99d421296a9cb0057b3cbf6eb12fb4a7d"
}

variable "DO_private_key" {
  type      = string
  sensitive = true
  default = "./fred.pem"
}

variable "DO_image" {
  type    = string
  default = "ubuntu-20-04-x64"
}

variable "DO_region" {
  type    = string
  default = "sgp1"
}

variable "DO_size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "ports" {
  type    = list(number)
  default = [8080, 8081, 8082, 8083]
}

variable "containers" {
  type = map(object({
    external_port = number
  }))

  default = {
    abc = {
      external_port : 1234
    }
    xyz = {
      external_port : 9090
    }
  }
}