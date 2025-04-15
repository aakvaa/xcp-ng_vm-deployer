terraform {
  required_providers {
    xenorchestra = {
      source = "vatesfr/xenorchestra"
      version = "~> 0.29.0"
    }
  }
  required_version = ">= 1.3.0" # Ajuste conforme a versão do Terraform
}

provider "xenorchestra" {
  url      = var.xenorchestra_url
  username = var.xenorchestra_username
  password = var.xenorchestra_password
  insecure = var.ignore_ssl
}

resource "xenorchestra_cloud_config" "vm" {
  name = "cloud config name"
  template = templatefile("${path.module}/cloud-init/${var.vm_os_template}.tpl", {
  vm_user     = var.vm_user
  vm_password = var.vm_password
  vm_name     = var.vm_name
  public_key  = var.public_key
})


}

data "xenorchestra_network" "net" {
  name_label = var.network_label
}
resource "xenorchestra_vm" "vm" {
  name_label        = var.vm_name
  name_description  = var.vm_description
  template          = var.vm_template
  cpus              = var.vm_cpu
  hvm_boot_firmware = "uefi"
  memory_max        = var.vm_ram * 1024 * 1024 * 1024
  network {
    network_id = data.xenorchestra_network.net.id
  }
  disk {
    name_label = var.vm_name
    sr_id      = var.vm_server
    size       = var.vm_disk * 1024 * 1024 * 1024
  }
  cloud_config = xenorchestra_cloud_config.vm.template
  timeouts {
    create = "15m"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = self.network[0].ipv4_addresses[0]
      user     = var.vm_user
      password = var.vm_password
    }

    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait",
      "echo 'Cloud-init completed successfully!'",
      "echo 'IP da VM: ${self.network[0].ipv4_addresses[0]}'",
      "echo 'User da VM: ${var.vm_user}'"
    ]
  }
}

output "vm_ip" {
  value = xenorchestra_vm.vm.network[0].ipv4_addresses[0]
  description = "Endereço IP da VM"
}

output "vm_user" {
  value = var.vm_user
  description = "Usuário da VM"
}

output "vm_status" {
  value = "done"
  description = "Status da criação da VM"
}
