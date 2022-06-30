data digitalocean_ssh_key chuk {
  name = "chuk"
}

data cloudflare_zone chuklee {
  name = "chuklee.com"
}

resource digitalocean_droplet code-server {
  name = var.code_server
  image = var.DO_image
  size = var.DO_size
  region = var.DO_region
  ssh_keys = [ data.digitalocean_ssh_key.chuk.id ]
}

resource cloudflare_record code-server {
  name = var.code_server
  zone_id = data.cloudflare_zone.chuklee.id 
  type = "A"
  value = digitalocean_droplet.code-server.ipv4_address
  proxied = true
}

resource local_file inventory_yaml {
  content = templatefile("inventory.yaml.tpl", {
    ssh_private_key = var.DO_private_key
    codeserver = var.code_server
    droplet_ip = digitalocean_droplet.code-server.ipv4_address
    codeserver_domain = "${var.code_server}.${var.cs_domain_name}"
    codeserver_password = var.cs_password
  })
  filename = "inventory.yaml"
  file_permission = "0444"
}

resource local_file root_at_nginx {
  content = ""
  filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
}

output nginx_ip {
  value = digitalocean_droplet.code-server.ipv4_address
}
