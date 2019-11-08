$global:cmd = @{
    "login" = "login.cgi"
    "pause" = "api/v1/serverstate/pause?duration="
    "resume" = "api/v1/serverstate/resume"
    "backups" = "api/v1/backups"
    "backup" = "api/v1/backup"
    "progressstate" = "api/v1/progressstate"
    "settings" = "api/v1/serversettings"
    "logdata_poll" = "api/v1/logdata/poll"
    "logdata_log" = "api/v1/logdata/log"
    "tasks" = "api/v1/tasks"
    "tasks_status" = "api/v1/tasks/status"
    "task" = "api/v1/task"
}

#[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("utf-8")
function DuplicatiUpdateHeaders {
    
    $global:cookies=$session.Cookies.GetCookies($Uri)
    #$cookies
    $global:token = ""

    foreach($c in $global:cookies){
        if ($c.Name -eq "xsrf-token") {
            $global:token=$c.Value
        }
        if ($c.Name -eq "session-auth") {
            $global:session_auth=$c.Value
        }
    }
    $global:headers =@{}
    $global:headers.Add("Content-Type", "text/plain;charset=UTF-8")
    $global:headers.Add("Accept-Encoding", "gzip, deflate")
    $global:headers.Add("Cookie",("xsrf-token="+$global:token+"; session-nonce="+[uri]::EscapeDataString($global:data.Nonce))+"; session-auth="+$global:session_auth)
    $global:headers.Add("Cache-Control","no-cache")
    $global:headers.Add("Accept","application/json, text/javascript, */*; q=0.01")
    $global:headers.Add("User-Agent","Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko")
    $global:headers.Add("X-Requested-With", "XMLHttpRequest")
    $global:headers.Add("Referer",$($global:Uri+"ngax/index.html"))
    $global:headers.Add("X-XSRF-Token", [uri]::UnescapeDataString($global:token))
}

function dGetCmd ($UriCmd) {
    DuplicatiUpdateHeaders

    $r = Invoke-RestMethod -Uri $($global:Uri+$UriCmd) -Method GET -Headers $global:headers -WebSession $global:session
    #write-host "r.length=",$r.length
    $s = ConvertFrom-Json $r.Substring(3)
    $s
    #write-host $s
 #  if ($s.Count -gt 0) {
 #       $s
 #   } else {
 #       write-host "Empty"
 #       $null
 #   }
}

function dAbortTask($ID) {
   DuplicatiUpdateHeaders
   $($global:Uri+$global:cmd.task+"/"+$ID+"/abort")
   $r = Invoke-RestMethod -Uri $($global:Uri+$global:cmd.task+"/"+$ID+"/abort") -Method POST -Body "" -Headers $global:headers -WebSession $global:session 
   $s = $($r.Substring(3) | ConvertFrom-Json)
   if ($s.Status -eq "OK") {
       write-host "Task ID#",$ID," aborted"
   } else {
       write-host "Error aborting task"
   }
   $s
}

function dGetTask($ID) {
    dGetCmd $($global:cmd.task+"/"+$ID)
}


function dGetTasksStatus {
    dGetCmd $global:cmd.tasks_status
}

function dGetTasksStatus1 {
   DuplicatiUpdateHeaders

   $r=Invoke-RestMethod -Uri $($global:Uri+$global:cmd.tasks_status) -Method GET -Headers $global:headers -WebSession $global:session
   $s = $r.Substring(3) | ConvertFrom-Json
   $s
#   if ($s.Count -gt 0) {
#       $s
#   } else {
#       write-host "Task list is empty"
#       $null
#   }
}

function dGetTasks {
    DuplicatiUpdateHeaders

    $r=Invoke-RestMethod -Uri $($global:Uri+$global:cmd.tasks) -Method GET -Headers $global:headers -WebSession $global:session
    #write-host "tasks-status"
    $tasks = $r.Substring(3) | ConvertFrom-Json
    $tasks
#    if ($tasks.Count -gt 0) {
#        $tasks
#    } else {
#        write-host "Task list is empty"
#        0
#    }
}

function dGetBackups {
    dGetCmd $global:cmd.backups
}

function dGetBackups1 {
    DuplicatiUpdateHeaders
    #$headers
    $r=Invoke-RestMethod -Uri $($global:Uri+$global:cmd.backups) -Method GET -Headers $global:headers -WebSession $global:session
    #$r=Invoke-RestMethod -Uri "http://localhost:8200/api/v1/backups" -Method GET -Headers $headers -WebSession $session
    #write-host "backups"
    $backups = $r.Substring(3) | ConvertFrom-Json
    $backups
 #   if ($backups.Count -gt 0) {
 #       $backups
 #   } else {
 #       write-host "Backups list is empty"
 #       0
 #   }
}

function dGetBackupByName($name, $b) {
    if ($b -ne $null -and ($name -ne "")) {
        foreach ($bb in $b) {
            if ( $bb.Backup.Name -eq $name ){
                $bb
            }
        }
    } else {
        0 
    }

}

function dGetBackupByID ($ID, $b) {
    if (($b -ne $null) -and ($ID -ne "")) {
        foreach ($bb in $b) {
            if ( $bb.Backup.ID -eq $ID ) {
                $bb
            }
        }
    } else {
        0
    }
}

function dGetBackupIndexByName($name,$b) { 
    #write-host "dGetBackupIndexByName: search name=",$name
    #Write-Host "Backups:",$q
    #Write-Host "Backups Count1:", $b.Count
    if (($b -ne $null) -and ($b.Count -gt 0) -and ($name -ne "")) {
        #write-host "dGetBackupIndexByName params ok"
        for ($i = 0; $i -lt $b.Count; $i++) {
            if ( $b[$i].Backup.Name -eq $name ){
                $i
            }
        }
    } else {
        -1
    }
}

function dGetBackupIndexByID ($ID, $b) {
    if (($b -ne $null) -and ($ID -ne "")) {
        for ($i=0;$i -lt $b.Count;$i++) {
            if ( $b[$i].Backup.ID -eq $ID ){
                $i
            }
        }
    } else {
        -1
    }
}

function dGetBackupByID1($ID) {
    $b = $(dGetCmd $($global:cmd.backup+"/"+$ID))
    $b.data.Backup
}

function dGetBackupByID_1($ID) {
    DuplicatiUpdateHeaders
    $r=Invoke-RestMethod -Uri $($global:Uri+$global:cmd.backup+"/"+$ID) -Method GET -Headers $global:headers -WebSession $global:session
    #write-host "backups"
    $backups = $r.Substring(3) | ConvertFrom-Json -
    #$backups.data 
    if (!$backups.success) {
        write-host "No backup ID#",$ID
        0
    } else {
        $backups.data.Backup
    }
}

function dSetBackup ($backup) {
  
    $body= $(ConvertTo-Json -Compress -Depth 100 $backup )
    DuplicatiUpdateHeaders
    $r=Invoke-RestMethod -Uri $($global:Uri+$global:cmd.backup+"/"+$backup.Backup.ID) -Method PUT -Body $body -Headers $global:headers -WebSession $global:session
    $s=ConvertFrom-Json $r.Substring(3)
    $s
}

#
function dGetSettings {
    dGetCmd $global:cmd.settings
}

function dGetSettings1 {
    DuplicatiUpdateHeaders
    $r = Invoke-RestMethod -Uri $($global:Uri+$global:cmd.settings) -Method GET -Headers $global:headers -WebSession $global:session
    #write-host "settingth"
    $s = ConvertFrom-Json $r.Substring(3)
    $s
    #if (($s -ne $null) -and ($s.Length -gt 0)) {
    #    $s
    #} else {
    #    $null
    #}
}

function dGetProgressstate {
    dGetCmd $global:cmd.progressstate
}

function dGetProgressstate1 {
    DuplicatiUpdateHeaders
    #$($global:Uri+$global:cmd.progress)
    #$r=Invoke-RestMethod -Uri "http://localhost:8200/api/v1/progressstate" -Method GET -Headers $global:headers -WebSession $global:session
    $r = Invoke-RestMethod -Uri $($global:Uri+$global:cmd.progressstate) -Method GET -Headers $global:headers -WebSession $global:session
    #write-host "progress state"
    
    $p = ConvertFrom-Json $r.Substring(3)
    $p
    
    #if (($p -ne $null) {
    #    $p
    #} else {
    #    $null
    #}
}


function dSetSpeed ($speed_dwn, $speed_up) {
    DuplicatiUpdateHeaders
    $sdwn="256KB"
    $sup="256KB"
   
    if ($speed_dwn -ne $null -and $speed_dwn -gt 0) {
        $sdwn=$(Format-HumanReadable1($speed_dwn))
    }

    if ($speed_up -ne $null -and $speed_up -gt 0) {
        $sup=$(Format-HumanReadable1($speed_up))
    }
    
    $body=$('{"max-download-speed":"'+$sdwn+'","max-upload-speed":"'+$sup+'"}')
    $body
    $r=Invoke-RestMethod -Uri $($global:Uri+$global:cmd.settings) -Method PATCH -Body $body -Headers $global:headers -WebSession $global:session
}

function dSetMaxSpeed {
    $speed=512*1024
    dSetSpeed $speed $speed
}

function dSetMidSpeed {
    $speed=1024*1024
    dSetSpeed $speed $speed
}

function dSetMinSpeed {
    $speed=256*1024
    dSetSpeed $speed $speed
}

function dRunBackup ($ID) {
    DuplicatiUpdateHeaders
    $r=Invoke-RestMethod -Uri $($global:Uri+$global:cmd.backup+$ID+"/run") -Method POST -Body "" -Headers $headers -WebSession $session
    #write-host "Run backup: 2"
    #$r
    $p = ConvertFrom-Json $r.Substring(3)
    $p
}