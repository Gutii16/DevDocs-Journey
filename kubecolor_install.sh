#!/bin/bash -e 

KUBECOLOR_URL="https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz"
KUBECOLOR_TAR="kubecolor_0.0.25_Linux_x86_64.tar.gz"

echo "Descargando kubecolor..."
wget $KUBECOLOR_URL

echo "Descomprimiendo el archivo..."
tar -zxvf $KUBECOLOR_TAR

if [ -f "kubecolor" ]; then
    echo "Moviendo kubecolor a /usr/local/bin..."
    sudo mv kubecolor /usr/local/bin/
else
    echo "kubecolor no se encontró después de descomprimir."
    exit 1
fi

echo "Verificando que kubecolor está en /usr/local/bin..."
if [ -f "/usr/local/bin/kubecolor" ]; then
    echo "kubecolor está instalado correctamente en /usr/local/bin."
else
    echo "kubecolor no se encontró en /usr/local/bin. Verifica tu instalación."
    exit 1
fi

echo "Agregando alias 'k=kubecolor'..."
echo "alias k='kubecolor'" >> ~/.bashrc

echo "Recargando .bashrc..."
source ~/.bashrc
alias k=kubectl

echo "Instalación y configuración de kubecolor completadas."
source ~/.bashrc