data digitalocean_ssh_key chuk {
  name = "chuk"
}
data digitalocean_droplet_snapshot code-server-image {
  name = "codeserver_${var.CS_version}"
}

data cloudflare_zone chuklee {
  name = "chuklee.com"
}

resource digitalocean_droplet code-server {
  name = var.CS_code_server
  image = data.digitalocean_droplet_snapshot.code-server-image.id
  size = var.DO_size
  region = var.DO_region
  ssh_keys = [ data.digitalocean_ssh_key.chuk.id ]
  connection {
    type = "ssh"
    user = "root"
    private_key = file(var.DO_private_key)
    host = self.ipv4_address
  }
  provisioner remote-exec {
    inline = [
      "sed -i -e 's/__SET_THIS__/${var.CS_password}/' /lib/systemd/system/code-server.service",
      "sed -i -e 's/__SET_THIS__/${var.CS_code_server}.chuklee.com/' /etc/nginx/sites-available/code-server.conf",
      "systemctl daemon-reload",
      "systemctl restart code-server",
      "systemctl restart nginx"
    ]
  }
}

resource cloudflare_record code-server {
  name = var.CS_code_server
  zone_id = data.cloudflare_zone.chuklee.id 
  type = "A"
  value = digitalocean_droplet.code-server.ipv4_address
  proxied = true
}

resource local_file root_at_nginx {
  content = ""
  filename = "root@${digitalocean_droplet.code-server.ipv4_address}"
}

output nginx_ip {
  value = digitalocean_droplet.code-server.ipv4_address
}
