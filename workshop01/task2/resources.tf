# docker image for app
data "docker_image" "northwind-app" {
  name = "stackupiss/northwind-app:v1"
}

# docker image for db
data "docker_image" "northwind-db" {
  name = "stackupiss/northwind-db:v1"
}

resource "docker_network" "mynet" {
  name = "mynet"
}

# Node Based app
resource "docker_container" "myapp" {
  name  = "myapp"
  image = data.docker_image.northwind-app.id
  env = [
    "DB_HOST=${docker_container.mydb.ip_address}", # data of DB server
    "DB_USER=root",
    "DB_PASSWORD=changeit"
  ]
  networks_advanced {
      name = docker_network.mynet.name
  }
  ports {
    internal = 3000
    external = 8081
  }
}

# docker volume for db
resource "docker_volume" "mydb_vol" {
  name = "shared_volume"
}

# DB Servers
resource "docker_container" "mydb" {
  name  = "mydb"
  image = data.docker_image.northwind-db.id
  networks_advanced {
      name = docker_network.mynet.name
  }  
  ports {
    internal = 3000
    external = 3306
  }
  volumes {
    container_path  = "/var/lib/mysql"
    #read_only = false
    #host_path = "/var/lib/mysql"      
    volume_name = docker_volume.mydb_vol.name
  }
}