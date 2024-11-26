## Configurar proxy para la terminal de CMD o POWERSHELL

Para configurar un proxy en la terminal (CMD o PowerShell), puedes añadir las siguientes variables con los comandos adecuados. Esto es útil, por ejemplo, en redes corporativas.

```bash
git config --global http.proxy http://xxxx:xxxx
git config --global https.proxy http://xxxx:xxxx
``` 
Después de configurar el proxy, ya podrás clonar repositorios externos desde detrás del proxy. Por ejemplo:

```bash
git clone https://xxxx.git
```
Si necesitas comprobar que el proxy está configurado correctamente, puedes verificarlo con:

```bash
git config --global --get http.proxy
git config --global --get https.proxy
```
## Desactivar el proxy o eliminar configuraciones SSL

Si ya no necesitas el proxy o deseas limpiar configuraciones relacionadas, puedes eliminarlas con el indicador `--unset`. Esto se aplica a configuraciones como `http.proxy`, `http.sslVerify`, o configuraciones específicas de dominios.

Para eliminar el proxy globalmente:

```bash 
git config --global --unset http.proxy
git config --global --unset https.proxy
```

Si configuraste opciones específicas para un dominio, elimina esas configuraciones con:

```bash
git config --global --unset http.https://dominio.com.proxy
git config --global --unset http.https://dominio.com.sslVerify
```

En caso de que hayas deshabilitado la verificación de SSL, puedes 
restablecerla para mejorar la seguridad:

```bash
git config --global --unset http.sslVerify
```
Para confirmar que las configuraciones se han eliminado correctamente, usa:

```bash 
git config  --list
```

## Deshabilitar el Proxy Temporalmente

Puedes deshabilitar la configuración del proxy de Git durante el comando de clonación:

```bash 
git -c http.proxy= -c https.proxy= clone https://xxxx.git
```

* `-c http.proxy=`: Anula cualquier proxy HTTP configurado.
* `-c https.proxy=`: Anula cualquier proxy HTTPS configurado.

Esto funciona solo para el comando en cuestión, sin afectar la configuración global o local.º