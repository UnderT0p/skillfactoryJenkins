terraform {
    required_providers {
      yandex = {
        source = "yandex-cloud/yandex"
      }
    }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "bcommon"
    region     = "ru-central1"
    
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}
resource "yandex_vpc_network" "networkans-1" {
  name = "network1"
}
resource "yandex_vpc_subnet" "subnetans-1" {
  name           = "subnetans1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.networkans-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
resource "yandex_compute_instance" "jenkinsci" {
  name = "jenkinsci"
  hostname = "jenkinsci"
  zone      = "ru-central1-a"
    resources {
        cores  = 4
        memory = 4
        core_fraction=5
    }
    boot_disk {
        
        initialize_params {
          
          image_id = "fd80iibe8asp4inkhuhr"#
          size=12
          type="network-hdd"
        }
    }
    network_interface {
      subnet_id = yandex_vpc_subnet.subnetans-1.id
      nat       = true
      ipv6 =false
    }
    metadata = {
      user-data = "${file("C:\\Users\\User\\Desktop\\terraform\\user.txt")}"
    }
    scheduling_policy {
      preemptible=true
    }
}
resource "yandex_compute_instance" "prod" {
  name = "prod"
  hostname = "prod"
  zone      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
    core_fraction=5
  }

  boot_disk {
   
      initialize_params {
       
        image_id = "fd80iibe8asp4inkhuhr"#deb10
        size=12
        type="network-hdd"
      }
   
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnetans-1.id
    nat       = true
    ipv6 =false
  }

  metadata = {
     user-data = "${file("C:\\Users\\User\\Desktop\\terraform\\user.txt")}"
  }
  scheduling_policy {
      preemptible=true
    }
}
resource "yandex_compute_instance" "stat" {
  name = "stat"
  hostname = "stat"
  zone      = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
    core_fraction=5
  }

  boot_disk {
   
      initialize_params {
       
        image_id = "fd80iibe8asp4inkhuhr"#deb10
        size=12
        type="network-hdd"
      }
   
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnetans-1.id
    nat       = true
    ipv6 =false
  }

  metadata = {
     user-data = "${file("C:\\Users\\User\\Desktop\\terraform\\user.txt")}"
  }
  scheduling_policy {
      preemptible=true
    }
}
output "internal_ip_address_jenkinsci" {
  value = yandex_compute_instance.jenkinsci.network_interface.0.ip_address
}

output "internal_ip_address_prod" {
  value = yandex_compute_instance.prod.network_interface.0.ip_address
}
output "internal_ip_address_stat" {
  value = yandex_compute_instance.stat.network_interface.0.ip_address
}

output "external_ip_address_jenkinsci" {
  value = yandex_compute_instance.jenkinsci.network_interface.0.nat_ip_address
}

output "external_ip_address_prod" {
  value = yandex_compute_instance.prod.network_interface.0.nat_ip_address
}
output "external_ip_address_stat" {
  value = yandex_compute_instance.stat.network_interface.0.nat_ip_address
}
