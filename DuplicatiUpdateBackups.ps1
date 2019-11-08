#backups for configure update
$bNames = "backup1","backup2","backup3"

. C:\Scripts\Duplicati\DuplicatiLogin.ps1
. C:\Scripts\Duplicati\DuplicatiFunc.ps1

#get cofigured backups
$backups = dGetBackups
#Write-Host "Backups Count:", $backups.Count
#$backups_json=$($backups | ConvertTo-Json)
#get running tacks
#$tasks = dGetTasks

#$backup=$( dGetBackupByID "1" $backups )
#$backup

#$backup=dGetBackupByName($("backup1"),$backups)
#$backup

foreach ($backup_name in $bNames ) {
    #write-host "Update backup:",$backup_name
    # get configured backup by name
    #$backup = $( dGetBackupByName $backup_name $backups )
    #$backup
    #Write-Host "Backups Count",$backup_name,":",$backups.Count
    $bi = $( dGetBackupIndexByName $backup_name $backups )
    #write-host "Backup index:", $bi
    #check if backup exists
    if ($bi -ge 0) {
        #$backups[$bi].Backup.ID
        $backup = $(dGetBackupByID1 $($backups[$bi].Backup.ID) )        
        #write-host "Backup Filter:",$backup.Filters[0].Expression
        #check if backup exists in task
#        $runing = dBackupInTask(,$tasks)

        $lastfile=Get-Childitem -Path \\u189527.your-storagebox.de\backup\dump -Filter ("*-"+$vmNumber+"-*.gz") | sort -Descending CreationTime |  select-object -first 1 | select Name
        
        #change file filter
        $backup.Filters[0].Expression=[String]$("*"+$lastfile.Name)

        $backup1=@{}

#        $backup1.Add("Backup",@{})
#        $backup1.Backup.Add("Filters", $backup.Backup.Filters)

        $backup1.Add("Backup",$backup)
        $backup1.Add("Schedule",$null)

#{"Backup":{"ID":"3","Name":"backup1","Description":"","Tags":[],"***",
#  "DBPath":"C:\Windows\system32\config\systemprofile\AppData\Local\Duplicati\***.sqlite",
#  "Sources":["***"],
#  "Settings":[{"Name":"encryption-module","Value":"aes","Filter":"","Argument":null},
#              {"Name":"compression-module","Value":"zip","Filter":"","Argument":null},
#              {"Name":"dblock-size","Value":"512MB","Filter":"","Argument":null},
#              {"Name":"passphrase","Value":"ke797e2aJt9EBE","Filter":"","Argument":null}],
#   "Filters":[{"Order":0,"Include":true,"Expression":"*-filename-2019_11_08-05_00_01.tar.gz"}],
#   "Metadata":{"LastBackupDate":"20190820T133243Z","BackupListCount":"1","TotalQuotaSpace":"0",
#               "FreeQuotaSpace":"0","AssignedQuotaSpace":"-1","TargetFilesSize":"447405751",
#               "TargetFilesCount":"3","TargetSizeString":"426,68 MB","SourceFilesSize":"451839234","SourceFilesCount":"1",
#               "SourceSizeString":"430,91 MB","LastBackupStarted":"20190821T070352Z","LastBackupFinished":"20190821T071509Z","LastBackupDuration":"00:11:16.9907942"},
#   "IsTemporary":false},
# "Schedule":null}

        #DuplicatiUpdateHeaders
        $r=dSetBackup $backup1
#    } else {
#        write-host "Not found"
    }
}
exit 0