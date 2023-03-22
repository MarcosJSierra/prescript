choco install microsoft-openjdk17 -y
choco install maven -y
choco install tomcat -y

Start-Process PowerShell -Verb runAs -ArgumentList '-command Copy-Item -force C:\prescript\configDocs\tomcat-users.xml -Destination C:\ProgramData\Tomcat9\conf'
Start-Process PowerShell -Verb runAs -ArgumentList '-command Copy-Item -force C:\prescript\configDocs\web.xml -Destination C:\ProgramData\Tomcat9\conf'

Get-Acl -Path 'C:\MYFILE.txt' | Select-Object -ExpandProperty Access | Format-Table -Autosize
(Get-Acl -Path 'C:\MYFILE.txt').Access | Format-Table -Autosize

# $PERMISSIONS = Get-ACL -Path "C:\ProgramData\Tomcat9\work"
# $NEWPERMISSION = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\USERS","FullControl","Allow")
# $PERMISSIONS.SetAccessRule($NEWPERMISSION)
# $PERMISSIONS | Set-Acl -Path "C:\ProgramData\Tomcat9\work"

# Get-Acl -Path 'C:\MYFILE.txt' | Select-Object -ExpandProperty Access | Format-Table -Autosize
# (Get-Acl -Path 'C:\MYFILE.txt').Access | Format-Table -Autosize