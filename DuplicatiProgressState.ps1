. C:\Scripts\Duplicati\DuplicatiLogin.ps1
. C:\Scripts\Duplicati\DuplicatiFunc.ps1

#progressstate
#{
#  "BackupID": "6",
#  "TaskID": 23,
#  "BackendAction": "Put",
#  "BackendPath": "duplicati-b***5.dblock.zip.aes",
#  "BackendFileSize": 1073695341,
#  "BackendFileProgress": 889225216,
#  "BackendSpeed": 106711,
#  "BackendIsBlocking": true,
#  "CurrentFilename": "***",
#  "CurrentFilesize": 171988247130,
#  "CurrentFileoffset": 8561664000,
#  "Phase": "Backup_ProcessingFiles",
#  "OverallProgress": 0.0,
#  "ProcessedFileCount": 0,
#  "ProcessedFileSize": 0,
#  "TotalFileCount": 10,
#  "TotalFileSize": 636493533146,
#  "StillCounting": false
#}

$ps = dGetProgressstate
#write-host $ps

if (($ps -ne $null) -and ($ps.Phase -ne "") -and ($ps.Phase -ne "Error")) {
    if ($ps.Phase -eq "Verify_Running") 
    {
#        write-host ($ps.Phase,":","{0:n2}%" -f ($ps.ProcessedFileSize*100/$ps.TotalFilesize)) ," ",$ps.TotalFileCount," files (",$(Format-HumanReadable($ps.TotalFileSize)),"), speed:",$(Format-HumanReadable($ps.BackendSpeed)),"/s time:",("{0:n2}h" -f ($ps.TotalFileSize/$ps.BackendSpeed/60/60))
        $speed=", speed: -"
        if ($ps.BackendSpeed -ge 0) {
            $speed = (", speed:"+(Format-HumanReadable($ps.BackendSpeed))+"/s time:"+("{0:n2}h" -f ($ps.TotalFileSize/$ps.BackendSpeed/60/60)))
        }
        write-host ($ps.Phase,":","{0:n2}%" -f ($ps.BackendFileProgress*100/$ps.BackendFileSize)) ," ",$ps.TotalFileCount," files (",$(Format-HumanReadable($ps.TotalFileSize)),")", $speed
    } elseif ($ps.Phase -eq "Backup_ProcessingFiles") {
        write-host $ps.Phase, " action:", $ps.BackendAction," current :",("{0:n2}%" -f ($ps.CurrentFileoffset*100/$ps.CurrentFilesize )),`
        " (",$(Format-HumanReadable($ps.CurrentFileoffset)),"/",$(Format-HumanReadable($ps.CurrentFilesize)),")"
        $speed=", speed: -"
        if ($ps.BackendSpeed -ge 0) {
            $speed = (", speed:"+(Format-HumanReadable($ps.BackendSpeed))+"/s time:"+("{0:n2}h" -f ($ps.TotalFileSize/$ps.BackendSpeed/60/60)))
        }
        write-host " total:",("{0:n2}%" -f ($ps.ProcessedFileSize*100/$ps.TotalFileSize)) ," ",$ps.ProcessedFileCount,"/",$ps.TotalFileCount,`
        " files (",$(Format-HumanReadable($ps.ProcessedFileSize)),"/",$(Format-HumanReadable($ps.TotalFileSize)),`
        ") ",$speed
    } else {
        write-host $ps
    }
}
