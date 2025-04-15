# Preparar um VM Template para o cloud-init

Guia completo pra preparar uma imagem base compatível com Terraform + Xen Orchestra usando cloud-init.

---

## 📦 Instalação dos pacotes necessários

```bash
apt-get update
apt-get install -y cloud-init cloud-utils cloud-initramfs-growroot
```

---

## ⚙️ Configuração do cloud-init

Edite o arquivo principal:

```bash
sudo nano /etc/cloud/cloud.cfg
```

Substitua ou adicione as seguintes configurações:

```yaml
datasource_list: [ NoCloud, ConfigDrive ]
datasource:
  ConfigDrive:
    dsmode: local
  NoCloud:
    fs_label: cidata

manage_resolv_conf: true
manage_etc_hosts: true
preserve_hostname: false
```

Se o usuário criado na VM **não for \`ubuntu\`**, substitua:

```yaml
users:
  - default
disable_root: true
```

Por algo como:

```yaml
users:
  - name: user
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
```

---

## 📌 Ordem dos módulos

Garanta que esses módulos estejam no início da lista de execução:

```yaml
 - set_hostname
 - update_hostname
 - update_etc_hosts
```

---

## 🧹 Remova arquivos desgraçados que atrapalham a config

```bash
rm -rf \\
  /etc/cloud/cloud.cfg.d/99-installer.cfg \\
  /etc/cloud/cloud.cfg.d/90_dpkg.cfg \\
  /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
```

---

## 🧼 Limpeza final da VM antes de virar template

```bash
rm -rf /etc/ssh/ssh_host_*
cloud-init clean --logs

# Limpar histórico do root e do usuário padrão
su - ubuntu
cat /dev/null > ~/.bash_history && history -c && exit
cat /dev/null > ~/.bash_history && history -c && exit
```

---

## 🐳 Exemplo de cloud-init com Docker e Timezone

```yaml
#cloud-config
users:
  - name: user
    plain_text_passwd: pass
    groups: sudo
    shell: /bin/bash
    lock_passwd: false

  - name: usuario_criado_durante_instalação
    shell: /usr/sbin/nologin
    lock_passwd: true
    inactive: true

runcmd:
  - echo "AllowUsers user" >> /etc/ssh/sshd_config
  - sed -i 's/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
  - rm -f /etc/ssh/ssh_host_*
  - rm -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
  - systemctl restart sshd
  - netplan apply
  - apt-get update
  - apt-get upgrade -y
  - apt-get install -y xe-guest-utilities ca-certificates curl apt-transport-https
  - install -m 0755 -d /etc/apt/keyrings
  - mkdir -p /etc/apt/keyrings
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  - chmod a+r /etc/apt/keyrings/docker.asc
  - echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  - apt-get update
  - apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  - timedatectl set-timezone America/Sao_Paulo
```

> ⚠️ Use os blocos `write_files:` e `netplan` se precisar configurar IP estático manualmente.  
> Caso use DHCP, **não precisa descomentar nada disso.**

---

## 🐧 Passos adicionais para Debian ou Kali

```bash
systemctl enable ssh.service
systemctl enable cloud-init-local.service
systemctl enable cloud-init-main.service
systemctl enable cloud-config.service
systemctl enable cloud-final.service
```

---

## 🧯 Finalizando

Após todos os ajustes e limpeza, desligue a VM e **converta para template**.  
Esse template estará pronto pra receber cloud-init no boot via Terraform, sem dor de cabeça.
