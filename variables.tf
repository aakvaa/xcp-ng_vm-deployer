variable "vm_name" {
  description = "Nome da VM"
  type        = string
}

variable "vm_template" {
  description = "Nome do template"
  type        = string
}

variable "vm_ram" {
  description = "Memoria RAM da VM"
  type        = number
}

variable "vm_disk" {
  description = "Tamanho do disco da VM"
  type        = number
}

variable "vm_cpu" {
  description = "Quantidade de VCPU"
  type        = number
}

variable "vm_server" {
  description = "Servidor onde a vm ficara hospedada"
  type        = string
}
variable "network_label" {
  description = "Interface de rede da VM"
  type        = string
}

variable "vm_user" {
  description = "Username for the VM"
  type        = string
}

variable "vm_password" {
  description = "Password for the VM"
  type        = string
  sensitive   = true  
}

variable "vm_description" {
  description = "Descrição da VM"
  type        = string
  default     = "Criada pelo Jenkins"
}

variable "xenorchestra_username" {
  description = "Usuário do Xen Orchestra"
  type = string
}

variable "xenorchestra_url" {
  description = "URL do Xen Orchestra"
  type = string
}

variable "xenorchestra_password" {
  description = "Senha do Xen Orchestra"
  sensitive   = true
}
variable "public_key" {
  description = "public_key"
  type = string
}

variable "ignore_ssl" {
  description = "Ignorar certificado ssl"
   type = bool
}

variable "vm_os_template" {
  description = "Tipo do sistema operacional (ubuntu|debian)"
  type        = string
}
