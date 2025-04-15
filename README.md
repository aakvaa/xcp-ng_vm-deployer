# VM-Deployer
![Terraform](https://img.shields.io/badge/Terraform-v1.3+-623CE4?logo=terraform)
![Xen Orchestra](https://img.shields.io/badge/XenOrchestra-Provider-blue)
![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)

Automação completa da criação de VMs em ambiente on-premise com **XCP-ng / Xen Orchestra** utilizando Terraform e cloud-init modular.

Esse projeto permite provisionar VMs Linux com configurações personalizadas de rede, disco, hostname e instalação de aplicações básicas como Docker.

## 🚀 Objetivo

Permitir o deploy automático de VMs com configurações padrão, prontas para uso, seja com **DHCP** ou com **IP fixo**.

## 🛠️ Tecnologias

- Terraform
- Xen Orchestra Provider (via websocket)
- cloud-init (modular)
- Shell script (`runcmd`)
- Templates `.tpl` com lógica condicional

## ⚙️ Pré-requisitos

- Template compatível com cloud-init no Xen Orchestra
- Terraform >= 1.3
- Template com suporte a LVM (caso use expansão de disco)
- API Websocket do Xen Orchestra habilitada (`wss://`)

## 📁 Estrutura

```bash
VM-Deployer/
├── cloud-init/
│   ├── debian12_cloud_init.tpl    # Criação de usuário, SSH e timezone
│   ├── ubuntu22.04_cloud_init.tpl # Hostname e rede (estática ou DHCP)
├── main.tf                        # Lógica principal
├── variables.tf                   # Declaração de variáveis
└── terraform.tfvars.example       # Exemplo de configuração
```

O `cloud-init` detecta e aplica automaticamente a configuração estática.

## 🧪 Execução

1. Clone o projeto:

```bash
git clone https://github.com/seuuser/VM-Deployer.git
cd VM-Deployer
```

2. Copie o arquivo de exemplo:

```bash
cp terraform.tfvars.example terraform.tfvars
```

3. Edite o `terraform.tfvars` com os valores do seu ambiente.

4. Rode:

```bash
terraform init
terraform apply
```

## 📦 Saídas

| Output      | Descrição               |
|-------------|-------------------------|
| `vm_ip`     | IP da VM criada         |
| `vm_user`   | Usuário criado na VM    |
| `vm_status` | Confirmação da criação  |

## 🔐 Segurança

- Variáveis sensíveis estão marcadas com `sensitive = true`
- Não comite `terraform.tfvars` com senhas reais
- Use secrets do pipeline (se aplicar)

## 🧱 Modularização

O `cloud-init` foi dividido em arquivos `.tpl`:

- `ubuntu22.04_cloud_init.tpl` – Configurações default para ubuntu + Docker
- `debian12_cloud_init.tpl` – Configurações default para debian + Docker

## 🧠 Melhorias futuras
- [ ] Modularizar o provisionamento
- [ ] Suporte a IP fixo via cloud-init
- [ ] Deploy com IP via input map
