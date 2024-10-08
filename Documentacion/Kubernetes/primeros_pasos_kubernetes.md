
Primeros Pasos en Kubernetes

Kubernetes es una plataforma de orquestación de contenedores de código abierto que automatiza la implementación, el escalado y la gestión de aplicaciones en contenedores. Si estás comenzando con Kubernetes, esta guía te proporcionará una documentación básica para que puedas empezar, incluyendo cómo montar un entorno en VirtualBox.

Índice

1. Introducción a Kubernetes
2. Conceptos Básicos
3. Requisitos Previos
4. Configuración del Entorno en VirtualBox
5. Instalación de Kubernetes con kubeadm
6. Verificación de la Instalación
7. Despliegue de una Aplicación Básica
8. Recursos Adicionales

---

Introducción a Kubernetes

Kubernetes (también conocido como K8s) gestiona clústeres de contenedores, permitiendo desplegar aplicaciones distribuidas de manera eficiente y escalable. Algunas de sus características principales incluyen:

- Automatización del despliegue y escalado: Kubernetes puede escalar automáticamente las aplicaciones según la demanda.
- Balanceo de carga: Distribuye el tráfico de red para garantizar la estabilidad.
- Gestión de configuración y secretos: Maneja configuraciones sensibles de manera segura.
- Auto-recuperación: Reinicia contenedores fallidos, reemplaza nodos, etc.

Conceptos Básicos

Antes de profundizar en la instalación, es importante entender algunos conceptos fundamentales de Kubernetes:

- Pod: La unidad más pequeña en Kubernetes, que puede contener uno o varios contenedores.
- Nodo: Una máquina (física o virtual) que ejecuta pods.
- Clúster: Conjunto de nodos que ejecutan aplicaciones en contenedores.
- Servicio (Service): Abstracción que define un conjunto lógico de pods y una política para acceder a ellos.
- Deployment: Controla la creación y actualización de pods.

Requisitos Previos

Antes de comenzar, asegúrate de tener lo siguiente:

- Máquina con VirtualBox instalado: https://www.virtualbox.org/wiki/Downloads
- Recursos del sistema recomendados:
  - CPU: Al menos 2 núcleos.
  - RAM: Mínimo 4 GB.
  - Almacenamiento: Al menos 20 GB libres.

Configuración del Entorno en VirtualBox

Para montar un entorno Kubernetes en VirtualBox, utilizaremos Vagrant, una herramienta que facilita la gestión de entornos virtuales.

Paso 1: Instalar Vagrant

Descarga e instala Vagrant desde https://www.vagrantup.com/downloads.

Paso 2: Crear un Directorio para el Proyecto

```bash
mkdir kubernetes-vbox
cd kubernetes-vbox
```

Paso 3: Inicializar Vagrant con una Máquina Virtual

Crea un archivo `Vagrantfile` con la siguiente configuración básica:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"  # Usa Ubuntu 20.04 LTS
  config.vm.hostname = "k8s-node"
  
  config.vm.network "private_network", type: "dhcp"
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
  end
  
  config.vm.provision "shell", inline: <<-SHELL
    # Actualizar paquetes
    sudo apt-get update -y
    
    # Instalar Docker
    sudo apt-get install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
    
    # Añadir el repositorio de Kubernetes
    sudo apt-get update -y
    sudo apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
    deb https://apt.kubernetes.io/ kubernetes-xenial main
    EOF
    
    # Instalar kubeadm, kubelet y kubectl
    sudo apt-get update -y
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    
    # Deshabilitar swap
    sudo swapoff -a
    sudo sed -i '/ swap / s/^\(.*\)$/#/g' /etc/fstab
    
    # Configurar sysctl para Kubernetes
    sudo modprobe overlay
    sudo modprobe br_netfilter
    
    sudo tee /etc/sysctl.d/k8s.conf <<EOF
    net.bridge.bridge-nf-call-iptables = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward = 1
    EOF
    
    sudo sysctl --system
  SHELL
end
```

Paso 4: Iniciar la Máquina Virtual

En el directorio del proyecto, ejecuta:

```bash
vagrant up
```

Esto creará y configurará la máquina virtual según el `Vagrantfile`.

Instalación de Kubernetes con kubeadm

Una vez que la máquina virtual esté lista, procederemos a inicializar el clúster de Kubernetes.

Paso 1: Acceder a la Máquina Virtual

```bash
vagrant ssh
```

Paso 2: Inicializar el Clúster

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

Este comando inicializará el clúster. Al finalizar, se te proporcionará un comando para unir nodos adicionales (si es necesario).

Paso 3: Configurar kubectl para el Usuario Actual

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Paso 4: Instalar una Red de Pods

Kubernetes requiere una red de pods para la comunicación entre ellos. Usaremos Flannel:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Verificación de la Instalación

Para asegurarte de que todo está funcionando correctamente, ejecuta:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

Deberías ver que el nodo está en estado `Ready` y que los pods del sistema están en ejecución.

Despliegue de una Aplicación Básica

Vamos a desplegar una aplicación sencilla para verificar el funcionamiento del clúster.

Paso 1: Crear un Deployment

```bash
kubectl create deployment hello-world --image=k8s.gcr.io/echoserver:1.4
```

Paso 2: Exponer el Deployment como un Servicio

```bash
kubectl expose deployment hello-world --type=NodePort --port=8080
```

Paso 3: Obtener el Puerto Asignado

```bash
kubectl get service hello-world
```

Busca el campo `NodePort` para ver el puerto asignado (por ejemplo, `30007`).

Paso 4: Acceder a la Aplicación

En tu navegador, accede a `http://<IP_DE_LA_MÁQUINA_VIRTUAL>:<NodePort>`. Puedes obtener la IP ejecutando `ip addr` en la máquina virtual.

Por ejemplo:

```
http://192.168.56.101:30007
```

Deberías ver una página que muestra detalles de la solicitud HTTP.

Recursos Adicionales

- Documentación Oficial de Kubernetes: https://kubernetes.io/es/docs/
- Tutoriales de Kubernetes: https://kubernetes.io/es/docs/tutorials/
- Vagrant y Kubernetes: https://www.vagrantup.com/docs/kubernetes

Conclusión

Esta guía te ha proporcionado una introducción básica a Kubernetes y te ha mostrado cómo montar un entorno local utilizando VirtualBox y Vagrant. A partir de aquí, puedes explorar más conceptos avanzados, como la gestión de múltiples nodos, configuraciones de red más complejas, y la implementación de aplicaciones más sofisticadas.

¡Buena suerte en tu viaje con Kubernetes!
