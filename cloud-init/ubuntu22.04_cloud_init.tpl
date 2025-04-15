#cloud-config
users:
  - name: ${vm_user}
    groups: sudo
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - ${public_key}

  - name: ubuntu
    shell: /usr/sbin/nologin
    lock_passwd: true
    inactive: true

runcmd:
  - echo "AllowUsers ${vm_user}" >> /etc/ssh/sshd_config
  - sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
  - rm -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
  - systemctl restart sshd
  - hostnamectl set-hostname ${vm_name}
  - growpart /dev/xvda 3
  - lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
  - resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
  - netplan apply
  - apt update && apt upgrade
  - apt install ca-certificates curl apt-transport-https xe-guest-utilities -y
  - install -m 0755 -d /etc/apt/keyrings
  - mkdir -p /etc/apt/keyrings
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  - chmod a+r /etc/apt/keyrings/docker.asc
  - echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  - apt-get update
  - sleep 10
  - apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  - timedatectl set-timezone America/Sao_Paulo
