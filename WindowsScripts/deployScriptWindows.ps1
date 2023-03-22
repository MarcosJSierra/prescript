choco install microsoft-openjdk17 -y
choco install maven -y
choco install tomcat -y

# Start-Process PowerShell -Verb runAs -ArgumentList '-command Copy-Item -force C:\prescript\configDocs\tomcat-users.xml -Destination C:\ProgramData\Tomcat9\conf'
# Start-Process PowerShell -Verb runAs -ArgumentList '-command Copy-Item -force C:\prescript\configDocs\web.xml -Destination C:\ProgramData\Tomcat9\conf'