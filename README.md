# Maven Application Compile and Deploy 

This script is intended to facilitate the process of install the basics tools to work with a maven project. This includes install Java, Maven, Tomcat, configurations of tomcat and system.

Also this script includes the posibility of create a war file and move it to the tomcat webapps folder to autodeploy this app. 

## System preparation

The first should be upgrade the system, so we will use the next command

```console
   sudo apt dit-upgrade
```

Then we will need to install and configure GIT to get acces to the repository with the script.

```
   sudo apt install git
```

## Script functions

The Script have two principal functions, first install all the tools needed to compile and install a proyect with maven. 

The first thing is get the repo to the machine. It's recommended to clone it in Documents since this directory is set by default in the script settings, requiring minimal changes to work.

```console
   cd ~/Documents
   git clone https://github.com/MarcosJSierra/prescript.git
```
This repo contains two thing, the script itself and a folder called _confiDocs_. In the folder we have the configurations files for Tomcat. We need to make some changes in the script. First we need to change the variable [SCRIPT_LOCATTION](./deployScript.sh#L17) (Click the link to see the line) for this we have two options. First just change the word CHANGE for the username or we can replace the full text. For the second option we will use the comand _pwd_

```console
cd ~/Documents/prescript
pwd
```

this will show the full path to the script folder container and we can copy this with CTRL+SHIFT+C. Then we need to edit the file. 
```
   nano ./deployScript.sh
```
Then we replace the direction of the script using CTRL+SHIFT+V. To save in nano we only ned to press CTRL + X, then press _y_ and Enter.

### Instalation

Before the installation its important to make some changes. First we need to define passwords for the users in Tomcat GUI. To make this edit the next file:
   * [tomcat-users.xml](./configDocs/tomcat-users.xml#L64) 

To run the script to install all the tools we only need to be in the directory and execute it. If you want to change the port of execution you can change the file [server.xml](./configDocs/server.xml#L68) but also change the script updating the varialbe [TOMCAT_PORT](./deployScript.sh#L26)
```
cd ~/Documents/prescript
./deployScript -i
```

The property _-i_ is for installation. With this automatically will update repositorys and install the latest version of Open JDK 17, also will download the tomcat server files. Then will realize all the required configurations to make Tomcat work. This will require the users password a few times so put it some atention while its working. At the end of the process tomcat can be administrated via sysmtectl with the next commands

* sudo systemctl start tomcat 
* sudo systemctl stop tomcat 
* sudo systemctl restart tomcat 
* sudo systemctl status tomcat 

### Deploy 
The Deploy Function requires some other changes. First we need to get the project to deploy. Then wee need to set the directory where the project is in the [deployScript](./deployScript.sh#L15) variable DIRECTORY_APP. Also we need to verify the path to webapp folder is the same for your system becouse its set to the default path for Ubuntu but it can change if you are using other distribution. Also we need to change the name of the variable APP_NAME to the name that gets tha war file will be generated. 

We supose the project its actually configurated to create a war for deploying in independent Tomcat. With all this we only need to run the script with the -d parameter. 
```
cd ~/Documents/prescript
./deployScript -d
```
This will require the password to make some operationts so give it some atenttion while is working. 

### Help
The script contains a little help if you don´t remember what makes the parammeters so you can use
```
./deployScipt -h
```

## Deploying Spring Boot App in a external Tomcat Server 
To deploy the app in a external tomcat server its needed to make some changes. The first its to comment the port configurations in Spring properties. Then we need to add the next dependency to the pom.xml
```XML
   <dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-tomcat</artifactId>
			<scope>provided</scope>
		</dependency>
```
Another change to make is after the project description we have to add the next property
```XML
   <name>prueba</name>
	<description>Prueba de despliegue en Tomcat10</description>
	<packaging>war</packaging>
```
Finally at the build section we need to add the property finalName. This property it's very important since this is the name of the war file we will generate. 
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