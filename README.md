# Linux Cluster Automation with Ansible

![Ansible](https://img.shields.io/badge/Ansible-2.10+-black?style=for-the-badge&logo=ansible)
![Platform](https://img.shields.io/badge/Platform-RHEL%20/%20CentOS%20/%20Rocky-blue?style=for-the-badge&logo=redhat)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

A comprehensive, production-ready Ansible project designed to deploy and manage a high-availability Linux cluster. This infrastructure automates the deployment of load balancers, application servers, database nodes, monitoring stacks, and storage gateways with a focus on security hardening and observability.

## 🚀 Overview

This repository provides a modular automation framework for:
*   **High Availability**: Frontend load balancing using HAProxy with SSL termination and dynamic backend discovery.
*   **Services Layer**: Apache/PHP web servers and MariaDB database nodes.
*   **Storage Gateway**: Centralized NFS server for shared data across the cluster.
*   **Monitoring & Observability**: Full stack including Prometheus, Alertmanager, and Node Exporter with dynamic scraping.
*   **Security Hardening**: 
    *   **SSH**: Automatic key generation, port customization (2222), and disabling of password/root login.
    *   **Firewall**: Granular `firewalld` rules with IP-based access control for management services.
    *   **SELinux**: Targeted policy enforcement with optimized booleans for cluster services.
*   **Infrastructure Management**: Static networking, NTP synchronization, and base package management.

---

## 📁 Project Structure

```text
.
├── inventory/                  # Inventory definitions
│   ├── hosts.yml               # Main inventory file (loadbalancers, app, db, nfs, monitoring)
│   ├── group_vars/             # Variables grouped by host categories (all, loadbalancers, servers)
│   └── host_vars/              # Host-specific overrides (e.g., nfs01.yml)
├── playbooks/                  # Execution playbooks
│   ├── site.yml                # Main entry point (orchestrates all layers)
│   ├── 01_infrastructure.yml   # Base setup (Common, Network, Firewall, SELinux, SSH, Auth)
│   ├── 02_services.yml         # Service layer (HAProxy, Web, MariaDB)
│   ├── 03_monitoring.yml       # Monitoring stack deployment
│   └── 05_nfs.yml              # NFS Storage Gateway setup
├── roles/                      # Modular logic
│   ├── common/                 # Base packages, Chrony (NTP), Timezone
│   ├── auth/                   # Active Directory / Kerberos integration
│   ├── firewall/               # Granular Firewalld rules management
│   ├── haproxy/                # HAProxy with dynamic backends and SSL
│   ├── mariadb/                # MariaDB installation and security
│   ├── monitoring/             # Combined Prometheus & Alertmanager role
│   ├── network/                # Dynamic NetworkManager configuration
│   ├── nfs_server/             # NFS Export management and service setup
│   ├── selinux/                # Context-aware SELinux enforcement
│   ├── ssh/                    # Key generation and SSHD hardening
│   └── web/                    # Apache/PHP application layer
├── vault/                      # Encrypted sensitive data (secrets.yml)
├── scripts/                    # Helper scripts (deploy.sh, encrypt.sh)
├── .vault_pass                 # Local vault password (ignored by git)
└── .gitignore                  # Git exclusion rules
```

---

## 🛠 Prerequisites

*   **Ansible**: Version 2.10 or higher.
*   **Python**: Python 3.x installed on the control node.
*   **Managed Nodes**: RHEL-based systems (CentOS, Rocky, AlmaLinux).
*   **SSH Access**: Initial access (root or sudo) for the first run.

Install required Ansible collections:
```bash
ansible-galaxy collection install -r requirements.yml
```

---

## ⚙️ Configuration

### 1. Inventory & Variables
Edit `inventory/hosts.yml` to define your cluster nodes.
Configure global settings in `inventory/group_vars/all.yml`, including:
*   `ssh_port`: Custom SSH management port (default: 2222).
*   `monitoring_group`: The inventory group hosting the monitoring stack.

### 2. SSH Key Management
The project automatically handles SSH keys:
*   **Control Node**: Generates `ansible_ed25519` key pair if missing.
*   **Managed Nodes**: Generates individual keys for the `ansible` user on each node.
*   **Public Keys**: Automatically distributed and authorized across the cluster.

### 3. Secrets & Vault
Sensitive data is stored in `vault/secrets.yml`.
*   A local `.vault_pass` file is used for seamless execution (ensure it's secured and excluded from git).
*   Use `ansible-vault` for manual encryption/decryption if needed.

---

## 🚢 Deployment

Execute the full stack deployment:
```bash
./scripts/deploy.sh
```

Or target specific layers using tags:
```bash
ansible-playbook playbooks/site.yml --tags infrastructure
ansible-playbook playbooks/site.yml --tags monitoring
```

---

## 📊 Feature Highlights

### 🛡 Security First
*   **SSH Hardening**: Custom port, root login disabled, public-key only.
*   **Firewall**: Only minimal required ports are opened. SSH can be restricted to specific management IPs.
*   **SELinux**: Fully enforcing with specific booleans like `haproxy_connect_any` enabled only where needed.

### 💾 Storage & Data
*   **NFS Gateway**: Centralized storage with dynamic export management via `nfs_exports` variable.
*   **MariaDB**: Secured installation with automated root password management via Vault.

### 📈 Monitoring
*   **Dynamic Scraping**: Prometheus automatically finds and scrapes all cluster nodes via inventory variables.
*   **Persistence**: `journald` is configured to persist logs across reboots on all nodes.

---

## 📝 License
This project is licensed under the MIT License - see the LICENSE file for details.
