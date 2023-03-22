# Scripts de automatización

A continuación se presentan Scripts para la instalación y configuración de las herramientas necesarias para el desarrollo de aplicaciones con Spring Boot y Java 17, asi como el despliegue en servidores externos Tomcat. Tambien se presentan Scripts para el despliegue de archivos war en servidores Tomcat todo esto con opciones para windows y linux. Para ver la documentación relacionada con cada caso se pueden revisar los siguientes enlaces.

* [Documentación de Scripts de Windows](./WindowsScripts/WindowsInstructions.md)
* [Documentación de Scripts de Linux](./LinuxScripts/LinuxInstructions.md)

## Deploying Spring Boot App in a external Tomcat Server

Para poder desplegar una aplicación de Springboot sobre un servidor Tomcat Externo es necesario verificar algunas cosas. Lo primero es ver que dentro de properties no se tenga configurado un puerto de ejecución, y si se tiene uno es necesario comentar esta linea. Segundo debemos agregar la siguiente dependencia al pom.xml de nuestro proyecto.

```XML
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-tomcat</artifactId>
  <scope>provided</scope>
</dependency>
```

Otro cambio necesario es agregar la propiedad packaging a nuestro pom.

```XML
<name>prueba</name>
<description>Prueba de despliegue en Tomcat10</description>
<packaging>war</packaging>
```

Finalmente, si queremos que el archivo war se genere siempre  con el mismo nombre debemos utilizar la propiedad finalName dentro de Build en el pom.

```XML
<build>
  <finalName>aplicacionEmpleos</finalName>
  <plugins>
    <plugin>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-maven-plugin</artifactId>
    </plugin>
  </plugins>
</build>
```
