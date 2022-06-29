variable "DO_token" {
  type      = string
  sensitive = true
  default   = "dop_v1_3ae7fa3a18a67a2886cacb22fc7e7bd99d421296a9cb0057b3cbf6eb12fb4a7d"
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