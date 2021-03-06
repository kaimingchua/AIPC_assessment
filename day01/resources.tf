data "digitalocean_ssh_key" "aipc-fred-key" {
  name = "aipc_fred_key"
}

# uses the 'latest' tag
data "docker_image" "dov-bear" {
  name = "chukmunnlee/dov-bear:v2"
}

resource "docker_container" "dov-bear-container" {
  count = length(var.ports)
  name  = "dov-bear-${count.index}"
  image = data.docker_image.dov-bear.id
  env = [
    "INSTANCE_NAME=myapp-${count.index}",
    "INSTANCE_HASH=${count.index}"
  ]
  ports {
    internal = 3000
    external = var.ports[count.index]
  }
}

resource "docker_container" "dov-bear-unique" {
  for_each = var.containers
  name     = each.key
  image    = data.docker_image.dov-bear.id
  env = [
    "INSTANCE_NAME=${each.key}",
  ]
  ports {
    internal = 3000
    external = each.value.external_port
  }
}

# resource "local_file" "container_name" {
#     filename = docker_container.dov-bear-unique[each.key].name
#     content = join(", ", [for c in docker_container.dov-bear-container: c.name])
# }

resource "digitalocean_droplet" "nginx" {
  name     = "nginx"
  image    = var.DO_image
  size     = var.DO_size
  region   = var.DO_region
  ssh_keys = [data.digitalocean_ssh_key.aipc-fred-key.id]
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.DO_private_key)
    host = self.ipv4_address
  }
  provisioner "remote-exec" {
      inline = [
          "apt-update",
          "apt-install nginx -y",
          "systemctl enable nginx",
          "systemctl start nginx"
      ]
  }
}

resource "local_file" "root_at_nginx" {
    content = ""
    filename = "root@${digitalocean_droplet.nginx.ipv4_address}"
}

output "nginx_ip_address" {
    value = digitalocean_droplet.nginx.ipv4_address
}

output "mykey_ssh_key" {
  value = data.digitalocean_ssh_key.aipc-fred-key.fingerprint
}

output "mykey_ssh_key_id" {
  value = data.digitalocean_ssh_key.aipc-fred-key.id
}

output "dov-bear-MD5" {
  value       = data.docker_image.dov-bear.repo_digest
  description = "SHA of the repo"
}

output "container-names" {
  value = [for c in docker_container.dov-bear-container : c.name]
}