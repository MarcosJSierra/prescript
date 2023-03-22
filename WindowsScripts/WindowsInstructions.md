# Scripts de instalación y despliegue

## Pre requisitos

Se requiere la instalación de [Chocolatey](https://chocolatey.org/install), para esto podemos ir al enlace sugerido arriba para poder instalar el software en cuestion. Con Chocolatey instalado abriremos una ventana de PowerShell como administradores y procedemos a instalar git con chocolatey para esto vamos a ejecutar los siguientes comandos.

```shell
Set-ExecutionPolicy -ExecutionPolicy unrestricted
choco install git -y
```

con esto listo vamos a cerrar y volver a abrir PowerShell como administradores para que se vuelvan a cargar las variables de entorno. 

## Script de instalación

Con git instalado procederemos a obtener el conjunto de scripts para la instalación. Para esto clonaremos el repositorio

```shell
cd C:\
git clone https://github.com/MarcosJSIerra/prescript.git
cd C:\prescript
```

> Es important etener en cuenta que los archivos de configuración incluyen los usuarios de acceso a Tomcat, es recomendable cambiar la contraseña de los mismos en el archivo [tomcat-users.xml](../configDocs/tomcat-users.xml#L64)

Ahora con esto listo podemos proceder a ejecutar el script. El script instalara y configurara tanto Java 17, como maven y Tomcat.

```shell

.\WindowsScripts\instalationScriptWindows.ps1

```
Ahora tendremos un Tomcat completamente funcional e instalando OpenJDK 17 asi como Maven.

## Script de despliegue

Para ejecutar el script de despligue solo hace falta copiar el archivo [deployScriptWindows.ps1](./deployScriptWindows.ps1) hacia una carpeta antes de la carpeta base de nuestro proyecto. Luego debemos editar dicho script cambiando la variable __$ProjectDir__. La variable que se encuentra dentro del texto no se debe cambiar, solo agregaremos el resto del path a partir de donde se encuentra el script. Asi si tenenmos la siguiente estructura de archivos:

```Shell
\Documentos
|
 --deployScript.ps1
|
 --\projectoMaven
   |
    ---\src
   |
    ---pom.xml
```

Nuestra variable deberia tener el siguiente valor

```Shell
    $ProjectDir = "${PSScriptRoot}/projectoMaven"
```

Ademas de esto debemos cambiar la variable, tambien dentro del script __$ProjectName__ esta debe recibir el nombre que va a recibir nuestro war. Este se define de una de las dos formas posibles

* Si se encuentra la tag <finalName> dentro de la sección <build> se usara la propiedad dentro de esta tag
* Si no se encuentra esta tag, se crea el nombre apartir de <artifactId> y <version> teniendo la estructura artifactid-version.war

Con esto en mente asignaremos el nombre que recibira la app al momento de compilarse. Con esto listo basta por ejecutar el script y este se encargar de lo demas. 