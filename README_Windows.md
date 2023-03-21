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

Ahora con esto listo podemos proceder a ejecutar el script. El script instalara y configurara tanto Java 17, como maven y Tomcat.

```shell
.\insatalationScriptWindows.ps1
```
