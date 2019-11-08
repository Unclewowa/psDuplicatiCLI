#users
. c:\Scripts\Duplicati\DuplicatiFunc.ps1
. c:\Scripts\Duplicati\DuplicatiLogin.ps1
#. c:\Scripts\Duplicati\sendMSG.ps1

#$headers
#DuplicatiUpdateHeaders

$b = dGetBackups
$i=5
#for ($i=0; $i -lt $b.Count; $i++) {
$b1=$b[$i].Backup
$target_url= $b1.TargetURL
write-host $("File list for backup:"+$b1.Name)
write-host $($target_url)


&"c:\Program Files\Duplicati 2\Duplicati.CommandLine.exe" find `
$($target_url) `
"*" `
--all-versions=1 `
--backup-name="$($b1.Name)" `
--dbpath="$($b1.DBPath)" `
--encryption-module=aes `
--compression-module=zip `
--passphrase=$($global:login_pwd)

#--dblock-size=512MB `
#--all-versions=1 `
#--version=2
#`
#--all-versions=1

#}