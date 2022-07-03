variable "DO_token" {
    type = string
    sensitive = true
}

variable "CS_version" {
  type = string
}

source digitalocean mydroplet {
    api_token = var.DO_token 
    image = "ubuntu-20-04-x64"
    size = "s-1vcpu-2gb"
    region = "sgp1"
    ssh_username = "root"
    snapshot_name = "codeserver_${var.CS_version}"
}

build {
    sources = [ "source.digitalocean.mydroplet" ]

    provisioner ansible {
        playbook_file = "playbook.yaml"
        extra_arguments = [
          "-e", "CS_version=${var.CS_version}"
        ]
    }
}
