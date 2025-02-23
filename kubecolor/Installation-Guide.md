# Guía para la instalación y configuración de **kubecolor**

Este tutorial está destinado a usuarios que no están familiarizados con Kubernetes y desean instalar y configurar **kubecolor**, una herramienta que mejora la legibilidad de la salida de los comandos de `kubectl` mediante colores. Sigue estos pasos para instalar kubecolor y configurarlo en tu sistema.

## Prerrequisitos

Antes de comenzar, asegúrate de tener:

1. **Sistema operativo:**
   - Linux (x86_64). Este tutorial es específico para sistemas Linux de 64 bits.
   - Ejemplos de distribuciones compatibles: Ubuntu, Debian, Fedora, CentOS, etc.

2. **Acceso a la terminal:**
   - Necesitarás acceso a la terminal de tu sistema, ya sea a través de una consola o un emulador de terminal.

3. **Permisos de administrador:**
   - Algunos pasos requieren permisos de administrador (sudo) para copiar archivos al directorio `/usr/local/bin/` y modificar archivos de configuración.

4. **Conexión a Internet:**
   - Necesitarás una conexión a Internet activa para descargar kubecolor desde GitHub.

5. **Herramientas necesarias:**
   - **`wget`**: Para descargar el archivo de kubecolor desde GitHub. Instálalo si no lo tienes con:
     ```bash
     sudo apt install wget
     ```
   - **`tar`**: Para descomprimir el archivo descargado. Generalmente ya está preinstalado en la mayoría de los sistemas Linux.
   - **Editor de texto** (como `vim` o `nano`): Para editar el archivo `~/.bashrc`. Si no tienes `vim`, instálalo con:
     ```bash
     sudo apt install vim
     ```

6. **Instalación previa de `kubectl` (opcional):**
   - Si ya tienes `kubectl` instalado, kubecolor reemplazará su salida estándar con colores. Si no lo tienes, puedes instalarlo con:
     ```bash
     sudo apt install kubectl
     ```

7. **Conocimientos básicos de la terminal:**
   - Debes estar familiarizado con los comandos básicos de la terminal como `cd`, `cp`, `ls`, y editar archivos de texto.

## Instalación de kubecolor

### Paso 1: Descargar el archivo de kubecolor

Ejecuta el siguiente comando para descargar la versión más reciente de kubecolor:

```bash
wget https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz
``` 

### Paso 2: Descomprimir el archivo
Una vez descargado el archivo, descomprimir el archivo con: 

```bash
tar xvf kubecolor_0.0.25_Linux_x86_64.tar.gz
``` 

### Paso 3: Hacer Kubecolor ejecutable

Asegurarse de que el archivo kubecolor sea ejecutable:

```bash
chmod +x kubecolor
```

Podemos listar los archivos del directorio para saber que se han generado correctamnente:

```bash
ls -lrt
```

### Paso 4: Probar kubecolor

```bash
./kubecolor get pod
./kubecolor get node
```

### Paso 5: Verificar el alias

Ejecuta el siguiente comando para verificar que el alias funcione correctamente:

```bash
kubectl get node
```

Si el comando genera un error como "not found", sigue los siguientes pasos para solucionar el problema.

```bash
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"
```

### Paso 6: Copiar kubecolor a una ubicación global

Para que kubecolor esté disponible en todo el sistema, cópialo al directorio `/usr/local/bin/`:

``` bash
sudo cp kubecolor /usr/local/bin/
```

### Paso 7: Configurar el alias de forma permanente
Para que el alias se cargue cada vez que abras una nueva terminal, agrégalo a tu archivo `~/.bashrc`:

``` bash
vim ~/.bashrc
``` 

Agrega las siguientes líneas al final del archivo:

``` bash
alias k=kubecolor
alias kubectl=kubecolor
complete -o default -F __start_kubectl k
```

Y por último recarga el archivo `~/.bashrc` para que los cambios surtan efecto:

``` bash
source ~/.bashrc
```

Verificación
Una vez que hayas realizado todos los pasos, verifica que kubecolor esté funcionando correctamente ejecutando:

``` bash
kubectl get node
kubectl get pod
``` 

Deberías ver la salida de estos comandos con colores, facilitando la lectura:

La etiqueta `--force-colors` se utiliza en Kubernetes para asegurar que los colores ANSI (usados para resaltar texto) se incluyan en la salida del comando, incluso cuando esta salida se redirige o se procesa a través de otros comandos (como `sort`, `grep`, etc.). 

Normalmente, los colores solo se habilitan automáticamente si el comando detecta que la salida va directamente a un terminal interactivo (TTY). Cuando la salida no va directamente a un terminal (por ejemplo, al redirigirla o usar pipes `|`), Kubernetes desactiva los colores por defecto.

