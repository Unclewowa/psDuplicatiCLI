. c:\Scripts\Duplicati\DuplicatiFunc.ps1
. c:\Scripts\Duplicati\DuplicatiLogin.ps1

#$r=Invoke-RestMethod -Uri "http://localhost:8200/api/v1/backup/3/run" -Method POST -Body "" -Headers $headers -WebSession $session
#write-host "Run backup: 2"
#$r

dRunBackup 1