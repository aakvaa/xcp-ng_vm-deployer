# === ACESSO AO XEN ORCHESTRA ===
xenorchestra_username = "USUARIO_DO_XO_AQUI"      # Usuário do XO
xenorchestra_password = "INSIRA_A_SENHA_DO_XO_AQUI"           # SENHA DO XO
xenorchestra_url      = "wss://xoa.local"      # URL do Xen orchestra, caso não tenha certificado usar ws:// 

# === CONFIGURAÇÕES DA VM ===
vm_name        = "vm-exemplo"                  # Nome da VM
vm_template    = "Nome do template"            # Nome exato do template no XO
vm_os_template = "ubuntu22.04_cloud_init"      # Template cloud-init usado no Terraform

vm_cpu         = 2                           # Quantidade de vCPUs
vm_ram         = 4                             # Memória em GB
vm_disk        = 60                            # Tamanho do disco em GB

vm_server      = "sr-uuid-aqui"                # UUID do Storage do XCP-NG Server destino
network_label  = "eth0"                        # Nome da interface de rede que será atrelada a VM

vm_user        = "myuser"                      # Nome do usuário da VM
public_key    = "sua chave publica"            # Public key
ignore_ssl     = false                         # ignroar certificado ssl
vm_description = "VM criada via Terraform"     # Descrição da VM
