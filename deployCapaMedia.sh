#!/bin/bash
#Script diseñado

: '
    CONFIGURACION DE PATHS PARA LOCALIZACION DE APLICACION, HERRAMIENTAS Y SCRIPT
    - DIRECTORY_APP: Debe tener el path hasta la carpeta raiz del proyecto, es decir donde se encuentra el archivo POM de la aplicacion.
    - DIRECTORY_APPS_TOMCAT: localicación del directorio webapps para el despliegue de los archivos war.
    - SCRIPT_LOCATION: localizacion del script que debe tener tanto el archivo de script como la carpeta configDocs.

'
# DIRECTORY_APP="/home/marcos/Documents/BDG/Banrural/POC/0001_Automatización_empaquetado/Codigo/empleos"
DIRECTORY_APP="/home/marcos/prueba" 
DIRECTORY_APPS_TOMCAT="/var/lib/tomcat10/webapps"
SCRIPT_LOCATION="home/marcos/Documents/BDG/Banrural/POC/0001_Automatización_empaquetado/Codigo/prescript"


: '
    CONFIGURACION DE TOMCAT
    - TOMCAT_VERSION: version de tomcat para su descarga o actualizacion.

'
TOMCAT_VERSION=10.1.7



: '
    CONFIGURACION DE INFORMACION DEL PROYECTO
    - WAR_NAME: nombre con el que se generara el archivo war.
    - DIRECTORY_APPS_TOMCAT: localicación del directorio webapps para el despliegue de los archivos war.
    - SCRIPT_LOCATION: localizacion del script que debe tener tanto el archivo de script como la carpeta configDocs.

'
WAR_NAME="aplicacionEmpleos.war"


: '
    CONFIGURACION DE COMANDOS DEL SISTEMA
    - PACKAGE_MANAGER: Manejador de paquetes del sistema.
    - INSTALL_COMMAND: comando de instalacion de aplicaciones.
    - UPDATE_COMMAND: comando para actualizacion de librerias.

'
PACKAGE_MANAGER="apt"
INSTALL_COMMAND="install"
UPDATE_COMMAND="update"



Help()
{
    echo "Script for install and deploy Capa Media API in Tomcat 10 Server"
    echo
    echo "Syntax: deployCapaMedia [-h|d|a]"
    echo "Options: "
    echo "h     Display help info"
    echo "d     compile, package and deploy project in Tomcat 10"
    echo "i     install all software required"
    echo "g     realice project git pull"
}

Deploy()
{
    echo "deploy"
    cd $DIRECTORY_APP || echo "No Home directory found" 
    mvn -v || echo "No maven found"
    mvn clean install
    sudo -K 
    sudo -S scp ./target/$WAR_NAME $DIRECTORY_APPS_TOMCAT
    ls $DIRECTORY_APPS_TOMCAT
}

Install()
{    
    if [ $SCRIPT_LOCATION = "cambiar" ]; then
        ErrorHeader
        echo "ERROR:"
        echo "  No se ha cambiado la variable SCRIPT_LOCATION"
    else

        if [ -d $SCRIPT_LOCATION ] && [ -f "${SCRIPT_LOCATION}/configDocs/server.xml" ] && [ -f "${SCRIPT_LOCATION}/configDocs/web.xml" ] && [ -f "${SCRIPT_LOCATION}/configDocs/tomcat-users.xml" ] && [ -f "${SCRIPT_LOCATION}/configDocs/tomcat.service" ];  then
            echo "Fase 1"
            sudo -K
            sudo -S $PACKAGE_MANAGER $UPDATE_COMMAND 
            sudo -S $PACKAGE_MANAGER $INSTALL_COMMAND git openjdk-17-jdk openjdk-17-doc openjdk-17-jre maven
            # 
            # Tomcat 10 Install
            # 
            #Add users
            echo "Fase 2"
            sudo -K
            sudo -S useradd -m -U -d /opt/tomcat -s /bin/false tomcat
            # Downloading Tomcat
            echo "Fase 3"
            wget https://dlcdn.apache.org/tomcat/tomcat-10/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz -P /tmp
            #upackaging and Creating Symbolic link
            echo "Fase 4"
            sudo -K
            sudo -S tar xzvf /tmp/apache-tomcat-$TOMCAT_VERSION.tar.gz -C /opt/tomcat/ 
            sudo -S ln -s /opt/tomcat/apache-tomcat-$TOMCAT_VERSION /opt/tomcat/latest

            echo "Fase 5"
            #Changing owner and permissions to files
            sudo -K
            sudo -S chown -R tomcat: /opt/tomcat
            sudo -S sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
            
            echo "Fase 6"
            #Creaing service file
            sudo -S cp $SCRIPT_LOCATION/configDocs/tomcat.service /etc/systemd/system/
            sudo -S systemctl daemon-reload
            sudo -S systemctl enable --now tomcat

            echo "Fase 7"
            #config firewall
            sudo -K
            sudo -S ufw allow 8080/tcp

            echo "Fase 8"
            # # Config tomcat gui
            sudo -S rm /opt/tomcat/latest/conf/tomcat-users.xml
            sudo -S cp $SCRIPT_LOCATION/configDocs/tomcat-users.xml /opt/tomcat/latest/conf/tomcat-users.xml

            sudo -S rm /opt/tomcat/latest/conf/server.xml
            sudo -S cp $SCRIPT_LOCATION/configDocs/server.xml /opt/tomcat/latest/conf/server.xml

            sudo -S rm /opt/tomcat/latest/conf/web.xml
            sudo -S cp $SCRIPT_LOCATION/configDocs/web.xml /opt/tomcat/latest/conf/web.xml
            sudo systemctl restart tomcat
        else 
            echo "ERROR:"
            echo "  Verifique las siguientes opciones de error:"
            echo "    * Que la direccion de SCRIPT_LOCATION sea valida, es decir, que incie con / y no finalice con /"
            echo "    * Que dentro de la localizacion a la que apunta SCRIPT_LOCATION se encuentre el directorio configDocs junto con los archivos web.xml, server.xml, tomcat-users.xml y tomcat.service"            
        fi
    fi

}


while getopts "hdi" option; do
    case $option in
        h) echo "hola"
        Help
        exit;;
        d) Deploy
        exit;;
        i) Install
        exit;;
        \?) #Invalid Option
        echo "Error: Invalid Option"
        exit;;
    esac
done

