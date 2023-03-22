# Maven Application Compile and Deploy

Este script tiene la intención de facilitar el proceso de instalar las herramientas basicas necesarias para trabajar y ejecutar el proeyecto de Maven. Esto incluye la instalación de Java Maven y Tomcat, asi como las configuraciones necesarias para hacer funcionar. Este script incluye la función de generar el archivo War del proyecto y desplegarlo dentro del servidor de Tomcat.

## System preparation

Lo primero que debemos hacer es actualizar el sistema, por lo que utilizaremos el siguiente comando

```console
   sudo apt dist-upgrade
```

Ahora instalaremos y configuraremos git.

```console
   sudo apt install git
```

## Script functions

El script como tal tiene dos funciones principales, la primera es instalar todas las herramientas necesarias para compilar e instalar el proyecto con maven.

Lo primero sera obter el repositorio. Lo recomendable es clonar el repositorio en Documents ya que algunas configuraciones vienen escritas para funcionar en este directorio y requieren cambios minimos.

```console
   cd ~/
   git clone https://github.com/MarcosJSierra/prescript.git
```

>Las siguientes instrucciones son opcionales.

Este repositorio contiene dos elementos, el primero seria el script en si mismo mientras el segundo seria un folder llamado _configDocs_, en este folder se encuentran los archivos de configuración para Tomcat. Pero para que funcione es neseario hacer algunos cambios en el Script. Primero que nada necesitamos cambiar la variable [SCRIPT_LOCATION](./deployScript.sh#L17) (El enlace anterior nos lleva a la linea del script) para esto tenemos dos opciones, la primera seria verificar que lo unico que cambie con la ruta actual del script y la carpeta sea el nombre de usuario, en dado caso unciamente tendriamos que hacer este cambio. La segunda opción seria usar el comando _pwd_.

```console
cd ~/prescript
pwd
```

Este comando nos mostrara en pantalla la direccion en la que nos encontramos, en esta caso deberia ser donde esta el Script, basta con seleccionar la linea y utilizar CTRL+SHIFT+C para copiarlo. Luego editaremos el script sustituyendo la ruta anterior con la nueva.  

```console
   nano ./LinuxScripts/deployScript.sh
```

para pegar el contenido basta con utilizar CTRL+SHIFT+V. Para guardar los cambios con nano cerraremos el editor con CTRL + X, luego presionaremos _y_ y Enter.

### Instalación

Antes de ejecutar la propiedad de instalación en el Script se deben hacer algunos cambios. Primero es aconsejable cambiar las contraseñas de los usuarios para el GUI de Tomcat. Para esto editaremos el siguiente archivo en la linea 64:

* [tomcat-users.xml](../configDocs/tomcat-users.xml#L64)

Para ejecutar el Script lo unico que necesitamos, luego de los cambios anteriores, es ir al lugar donde almacenamos el Script. Si se desea cambiar el puerto de escucha de Tomcat podemos cambiar el siguiente archivo, en la linea 68, [server.xml](../configDocs/server.xml#L68) y tambien, en dado caso, debemos cambiar el script para configurar el firewall [TOMCAT_PORT](./deployScript.sh#L26). Para ejecutar el Script usremos los siguientes comandos.

```console
cd ~/prescript
./LinuxScripts/deployScript.sh -i
```

La propiedad _-i_ es la utilizada para la instalación. El script actualizara los repositorios del sistema e instalara la ultima versión de Java 17, tambien descargara la versión indicada de tomcat y hara todas las configuraciones necesarias para que Tomcat funcione. En algunos momentos de la ejecución solicitara la contraseña del usuario por lo que es necesario estar atento para introducir la misma. Una vez se ha completado el proceso es posible controlar Tomcat por medio de Systemctl con los siguientes comandos.

* sudo systemctl start tomcat9
* sudo systemctl stop tomcat9
* sudo systemctl restart tomcat9
* sudo systemctl status tomcat9

### Deploy

La función de despliegue requiere de otros cambios. Lo primero es que debemos obtener el proyecto a deployar. Luego necesitamos definir dentro del script el directorio donde el proyecto se encuenta, esto lo haremos en la  variable DIRECTORY_APP del archvio [deployScript](./deployScript.sh#L15). Tambien debemos verificar que el path hacia la carpeta Webapp de Tomcat, que es donde almacena los archivos war, sea la misma para nuestro SO, en el caso del script esta configurado para funcionar en Ubuntu, pero por ejemplo en Arch Linux el path se encuentra en _/var/lib/tomcatn/webapps_. Tambien dentro del script debemos verificar que el nombre del archivo war generado coinicda con la variable APP_NAME.

> En este punto suponemos que el proyecto esta configurado para generar un archivo war por medio de los comandos de maven, asi como generarlo con el nombre que se ha indicado en el script.

```console
cd ~/prescript
./deployScript -d
```

Al igual que con isntalación nos pedira la contraseña en algun momento por lo que es importante estar atento.

### Help

El comando -h nos desplegara una pequeña ayuda de los parametros aceptados por el

```console
./LinuxScripts/deployScipt -h
```

## Extra: Agregar Alias para facilitar el despliegue

Para facilitar el uso de nuestro script podemos agregar un aliasa que nos haga mas facíl el proceso de ejecutarlo. Lo primero que haremos es editar nustro archvio bashrc.

```console
cd ~/
nano .bashrc
```

luego al final del archivo vamos a agregar lo siguiente

```console
alias deployProject="${HOME}/prescript/ScriptsLinux/deployScript.sh -d"
```

Guardaremos con CTRL+X y presionando luego "Y" y Enter. Ahora solo recargaremos las configuraciones del bash 

```console
source ~/.bashrc
```
