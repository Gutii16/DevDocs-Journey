# 🛠️ Guía para Crear un Laboratorio DevOps con Kubernetes

En esta guía, aprenderás a:
- ✅ Configurar máquinas virtuales con **Ubuntu Server 22.04 LTS**
- ✅ Instalar **Docker, Kubernetes, Helm y herramientas DevOps**
- ✅ Crear un **clúster Kubernetes con kubeadm**
- ✅ Desplegar aplicaciones con **Helm y CI/CD**

---

## 🏗️ Paso 1: Crear Máquinas Virtuales
Usaremos **VirtualBox** (o Proxmox/KVM si prefieres).

### 📥 Descargar Ubuntu Server 22.04 LTS
[Descargar ISO de Ubuntu Server](https://ubuntu.com/download/server)

### 📌 Configurar las VMs en VirtualBox
1. **Abrir VirtualBox** → Crear **3 VMs**:
   - `k8s-master` (Nodo Master)
   - `k8s-worker-1` (Nodo Worker 1)
   - `k8s-worker-2` (Nodo Worker 2)

2. **Configurar Hardware**:
   - **CPU**: 2 vCPUs
   - **RAM**: 4 GB (mínimo)
   - **Disco**: 40 GB para Master, 30 GB para Workers
   - **Red**: Configurar en **Red Interna** o **Puente** para que puedan comunicarse

3. **Instalar Ubuntu Server** en cada VM con estas opciones:
   - **Idioma**: Español o Inglés
   - **Tipo de instalación**: Mínima
   - **Nombre de usuario**: `ubuntu`
   - **Habilitar OpenSSH** (para conexión remota)

4. **Actualizar el sistema**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

---

## ⚙️ Paso 2: Instalar Docker y Kubernetes
Ejecutar en **todas las VMs** (`k8s-master` y `k8s-workers`).

### 🔹 Instalar Dependencias
```bash
sudo apt install -y curl apt-transport-https ca-certificates software-properties-common
```

### 🐳 Instalar Docker
```bash
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

### ☸️ Instalar Kubernetes (kubeadm, kubelet, kubectl)
```bash
sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubeadm kubelet kubectl
sudo systemctl enable --now kubelet
```

### 🔄 Desactivar Swap (requerido por Kubernetes)
```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

---

## 🚀 Paso 3: Configurar el Clúster Kubernetes
Ejecutar **solo en `k8s-master`**.

### 🔹 Inicializar el Clúster
```bash
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

### 📂 Configurar acceso a `kubectl`
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 🌐 Instalar la Red Calico
```bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

---

## 🔗 Paso 4: Agregar los Nodos Workers
Ejecutar en **cada nodo worker** (`k8s-worker-1` y `k8s-worker-2`).

1. Usa el comando que imprimió `kubeadm init`, por ejemplo:
   ```bash
   sudo kubeadm join 192.168.1.100:6443 --token abcdef.1234567890abcdef --discovery-token-ca-cert-hash sha256:xxxxxxxxxxxx
   ```

2. Verificar en el **nodo master** que los workers se unieron:
   ```bash
   kubectl get nodes
   ```

---

## 🎯 Paso 5: Instalar Helm y Herramientas DevOps
Ejecutar en `k8s-master`.

### ⎈ Instalar Helm
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### 📦 Instalar un Chart de Prueba (NGINX)
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-nginx bitnami/nginx
kubectl get pods
```

---

## 🏗️ Paso 6: Agregar CI/CD con GitHub Actions

1. **En GitHub**, ve a **Settings → Secrets** y agrega:
   - `KUBECONFIG` → Contenido de `~/.kube/config` en `k8s-master` (base64 codificado).

2. **Crear `.github/workflows/deploy.yaml` en tu repo**:
   ```yaml
   name: Deploy to Kubernetes

   on:
     push:
       branches:
         - main

   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
         - name: Checkout Repo
           uses: actions/checkout@v3

         - name: Set up kubectl
           run: |
             echo "${{ secrets.KUBECONFIG }}" | base64 --decode > kubeconfig.yaml
             export KUBECONFIG=kubeconfig.yaml

         - name: Deploy App
           run: kubectl apply -f kubernetes/
   ```

---

## 🎉 ¡Listo! Tu Laboratorio DevOps está Configurado
Ahora puedes:
- ✅ **Desplegar aplicaciones** con Kubernetes y Helm
- ✅ **Configurar CI/CD** con GitHub Actions
- ✅ **Monitorear el clúster** con Prometheus y Grafana

---

## 🛠️ Extras y Mejoras
- **Automatizar la instalación con Ansible y Terraform**
- **Configurar un Ingress Controller con Traefik o Nginx**
- **Agregar herramientas como ArgoCD o Flux para GitOps**
