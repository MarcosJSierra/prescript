$ProjectDir = "${PSScriptRoot}/cambiar"
$ProjectName = "cambiar"

cd $ProjectDir
mvn clean install

cd "${ProjectDir}/target/${ProjectName}.war"
Start-Process PowerShell -Verb runAs -ArgumentList '-command Copy-Item -force ${ProjectDir}/target/${ProjectName}.war -Destination C:\ProgramData\Tomcat9\webapps'
