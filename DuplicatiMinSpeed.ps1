﻿. c:\Scripts\Duplicati\DuplicatiFunc.ps1
. c:\Scripts\Duplicati\DuplicatiLogin.ps1

#$body='{"max-download-speed":"200KB","max-upload-speed":"200KB"}'
#$r=Invoke-RestMethod -Uri "http://localhost:8200/api/v1/serversettings" -Method PATCH -Body $body -Headers $headers -WebSession $session
#$speed = 5*1024*1024
#$speed = 256*1024
$speed = 512*1024
$d=(Get-Date).DayOfWeek.value__
if (($d -le 5) -and ($d -gt 0)) {
    dSetSpeed $speed $speed
}