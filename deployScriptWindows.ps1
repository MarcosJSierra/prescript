chocolatey install microsoft-openjdk17 -y
chocolatey install maven -y
chocolatey install tomcat -y

Start-Process PowerShell -Verb runAs -ArgumentList '-comand Copy-Item -force C:\prescript\configDocs\tomcat-users.xml -Destination C:\ProgramData\Tomcat9\conf'
Start-Process PowerShell -Verb runAs -ArgumentList '-comand Copy-Item -force C:\prescript\configDocs\web.xml -Destination C:\ProgramData\Tomcat9\conf'