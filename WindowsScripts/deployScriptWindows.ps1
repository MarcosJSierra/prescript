$ProjectDir = "${PSScriptRoot}\cambiar"
$ProjectName = "cambiar"

cd $ProjectDir
mvn clean install

Copy-Item -force ${ProjectDir}\target\${ProjectName}.war -Destination C:\ProgramData\Tomcat9\webapps
