#!/bin/bash
: '
    Este script tiene como cometido el facilitar el proceso de instalación de paquetes dentro de sistemas operativos Ubuntu.

'

: '
    CONFIGURACION DE PATHS PARA LOCALIZACION DE APLICACION, HERRAMIENTAS Y SCRIPT
    - DIRECTORY_APP: Debe tener el path hasta la carpeta raiz del proyecto, es decir donde se encuentra el archivo POM de la aplicacion.
    - DIRECTORY_APPS_TOMCAT: localicación del directorio webapps para el despliegue de los archivos war.
    - SCRIPT_LOCATION: localizacion del script que debe tener tanto el archivo de script como la carpeta configDocs.

'

DIRECTORY_APP="cambiar"
DIRECTORY_APPS_TOMCAT="/var/lib/tomcat9/webapps"
CONFIG_SERVER_DIRECTORY="cambiar"
SCRIPT_LOCATION="${HOME}/prescript"


: '
    CONFIGURACION DE TOMCAT
    - TOMCAT_VERSION: version de tomcat para su descarga o actualizacion.

'
TOMCAT_PORT=8080

: '
    CONFIGURACION DE INFORMACION DEL PROYECTO
    - APP_NAME: El nombre con el que se genera el archivo de la aplicación.

'
APP_NAME="cambiar"
CONFIG_SERVER_NAME="cambiar"

: '
    CONFIGURACION DE COMANDOS DEL SISTEMA
    - PACKAGE_MANAGER: Manejador de paquetes del sistema.
    - INSTALL_COMMAND: comando de instalacion de aplicaciones.
    - UPDATE_COMMAND: comando para actualizacion de librerias.

'
PACKAGE_MANAGER="apt"
INSTALL_COMMAND="install"
UPDATE_COMMAND="update"

Help() {
    echo "Script for install and deploy Capa Media API in Tomcat 10 Server"
    echo
    echo "Syntax: deployCapaMedia [-h|d|a]"
    echo "Options: "
    echo "h     Display help info"
    echo "d     compile, package and deploy project in Tomcat 10"
    echo "i     install and configure all software required"
}

Deploy() {


    if [ "$(mvn -v)" ]; then
        if [ -d $DIRECTORY_APP ] && [ -d $DIRECTORY_APPS_TOMCAT ]; then
            cd $DIRECTORY_APP || echo ""
            if [ -f ./pom.xml ]; then

                mvn clean install
                ls $DIRECTORY_APP/target
                if [ -f $DIRECTORY_APP/target/$APP_NAME.war ]; then
                    sudo -K
                    # sudo -S rm
                    sudo -S cp $DIRECTORY_APP/target/$APP_NAME.war $DIRECTORY_APPS_TOMCAT
                    if [ -f $DIRECTORY_APPS_TOMCAT/$APP_NAME.war ]; then
                        echo "Proceso completado"
                    fi
                else
                    echo "ERROR:"
                    echo "  No se encontro el archivo ${WAR_NAME} por favor revise los siguientes puntos:"
                    echo "    * Que se haya generado correctamente el archivo WAR"
                    echo "    * Que se tengas las confugraciones correctas en POM.xml"
                fi
            else
                echo "ERROR:"
                echo "  No se ha encontrado nignun archivo POM.xml en el directorio ${DIRECTORY_APP}"
            fi

        else
            echo "ERROR:"
            echo "  No existe alguno de los siguientes directorios, por favor revise la sintaxis de la variable o bien revise que existan los directorios"
            echo "    * ${DIRECTORY_APP}"
            echo "    * ${DIRECTORY_APPS_TOMCAT}"

        fi
    else
        echo "ERROR:"
        echo "  No se ha encontrado una versión instalada de Maven, por favor instale maven y vuelva a intentar el despliegue"

    fi

}

DeployConfigServer() {


    if [ "$(mvn -v)" ]; then
        if [ -d $CONFIG_SERVER_DIRECTORY ] && [ -d $DIRECTORY_APPS_TOMCAT ]; then
            cd $CONFIG_SERVER_DIRECTORY || echo ""
            if [ -f ./pom.xml ]; then

                mvn clean install
                ls $CONFIG_SERVER_DIRECTORY/target
                if [ -f $CONFIG_SERVER_DIRECTORY/target/$APP_NAME.war ]; then
                    sudo -K
                    # sudo -S rm
                    sudo -S cp $CONFIG_SERVER_DIRECTORY/target/$CONFIG_SERVER_NAME.war $DIRECTORY_APPS_TOMCAT
                    if [ -f $DIRECTORY_APPS_TOMCAT/$CONFIG_SERVER_NAME.war ]; then
                        echo "Proceso completado"
                    fi
                else
                    echo "ERROR:"
                    echo "  No se encontro el archivo ${WAR_NAME} por favor revise los siguientes puntos:"
                    echo "    * Que se haya generado correctamente el archivo WAR"
                    echo "    * Que se tengas las confugraciones correctas en POM.xml"
                fi
            else
                echo "ERROR:"
                echo "  No se ha encontrado nignun archivo POM.xml en el directorio ${DIRECTORY_APP}"
            fi

        else
            echo "ERROR:"
            echo "  No existe alguno de los siguientes directorios, por favor revise la sintaxis de la variable o bien revise que existan los directorios"
            echo "    * ${DIRECTORY_APP}"
            echo "    * ${DIRECTORY_APPS_TOMCAT}"

        fi
    else
        echo "ERROR:"
        echo "  No se ha encontrado una versión instalada de Maven, por favor instale maven y vuelva a intentar el despliegue"

    fi

}


Install() {

    if [ -d $SCRIPT_LOCATION ] && [ -f "${SCRIPT_LOCATION}/configDocs/server.xml" ] && [ -f "${SCRIPT_LOCATION}/configDocs/web.xml" ] && [ -f "${SCRIPT_LOCATION}/configDocs/tomcat-users.xml" ] && [ -f "${SCRIPT_LOCATION}/configDocs/tomcat.service" ]; then

        : '
                Instalación de paquetes y librerias para el funcionamiento del proyecto.
            '
        sudo -K
        sudo -S $PACKAGE_MANAGER $UPDATE_COMMAND
        sudo -S $PACKAGE_MANAGER $INSTALL_COMMAND openjdk-17-jdk openjdk-17-doc openjdk-17-jre maven tomcat9 tomcat9-admin tomcat9-docs tomcat9-examples tomcat9-common tomcat9-user

        : '
                Configuración de el firewall
            '
        sudo -K
        sudo -S ufw allow $TOMCAT_PORT/tcp

        : '
                Actualizacion de los archivos de configuracion de tomcat
            '
        if [ -f /etc/tomcat9/tomcat-users.xml ] && [ -f /etc/tomcat9/server.xml ] && [ -f /etc/tomcat9/web.xml ]; then

            sudo -S rm /etc/systemd/system/multi-user.target.wants/tomcat9.service
            sudo -S cp $SCRIPT_LOCATION/configDocs/tomcat9.service /etc/systemd/system/multi-user.target.wants/tomcat9.service
            sudo -S systemctl daemon-reload
            sudo -S systemctl enable tomcat9
            sudo -S systemctl start tomcat9

            
            sudo -S rm /etc/tomcat9/tomcat-users.xml
            sudo -S cp $SCRIPT_LOCATION/configDocs/tomcat-users.xml /etc/tomcat9/tomcat-users.xml

            sudo -S rm /etc/tomcat9/server.xml
            sudo -S cp $SCRIPT_LOCATION/configDocs/server.xml /etc/tomcat9/server.xml

            sudo -S rm /etc/tomcat9/web.xml
            sudo -S cp $SCRIPT_LOCATION/configDocs/web.xml /etc/tomcat9/web.xml
            sudo systemctl restart tomcat9
        else
            echo "ERROR:"
            echo "  No se han encontrado los archivos de configuración de Tomcat en el sistema, por favor intente volver a ejecutar el script."
        fi
    else
        echo "ERROR:"
        echo "  Verifique las siguientes opciones de error:"
        echo "    * Que la direccion de SCRIPT_LOCATION sea valida, es decir, que incie con / y no finalice con /"
        echo "    * Que dentro de la localizacion a la que apunta SCRIPT_LOCATION se encuentre el directorio configDocs junto con los archivos web.xml, server.xml, tomcat-users.xml y tomcat.service"
    fi

}

while getopts "hdic" option; do
    case $option in
    h)
        Help
        exit
        ;;
    d)
        Deploy
        exit
        ;;
    i)
        Install
        exit
        ;;
    c)
        DeployConfigServer
        exit
        ;;
    \?) #Invalid Option
        echo "Error: Invalid Option"
        Help
        exit
        ;;
    esac
done
