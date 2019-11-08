#$global:headers=$null
#$global:cookies=$null
#$global:token=""
#$global:login_pwd=""
#$global:Uri=""
#$global:session=$null

. c:\Scripts\Duplicati\DuplicatiFunc.ps1
. c:\Scripts\Duplicati\DuplicatiLogin.ps1
. c:\Scripts\Duplicati\sendMSG.ps1

$file="c:\Scripts\Duplicati\info1.csv"

$b = dGetBackups

$Content="<table class='normal'>"
$Content+="<tr><td>BackupID</td><td>BackupName</td><td>LastBackupDate</td><td>BackupListCount</td><td>TargetFilesSize</td><td>TargetFilesCount</td><td>TargetSizeString</td><td>SourceFilesSize</td><td>SourceFilesCount</td><td>SourceSizeString</td><td>LastBackupStarted</td><td>LastBackupFinished</td><td>LastBackupDuration</td></tr>"

foreach ($b1 in $b) {
    #write-host $b1.Backup
    $backup = $(dGetBackupByID1 $($b1.Backup.ID) )
    if ($backup.Metadata -ne $null) {
        #$Content+=$("<b>"+$backup.ID+" "+$backup.Name+"</b><br/>")
        $s = "<tr><td>"+$($backup.ID)+"</td><td>"+$($backup.Name)+"</td><td>"
        $md=$backup.Metadata
#{ "LastErrorDate": "20190827T151308Z", "LastErrorMessage": "", "LastBackupDate": "20190903T182336Z", "BackupListCount": "3", "TotalQuotaSpace": "0", "FreeQuotaSpace": "0", "AssignedQuotaSpace": "-1", "TargetFilesSize": "585622040351", "TargetFilesCount": "2187", "TargetSizeString": "545,40 ÐÐ", "SourceFilesSize": "222666596262", "SourceFilesCount": "1", "SourceSizeString": "207,37 ÐÐ", "LastBackupStarted": "20190903T182320Z", "LastBackupFinished": "20190904T035639Z", "LastBackupDuration": "09:33:18.1490128" }

        $s+=$(dateConvert $($md.LastBackupDate))+"</td><td>"
        $s+=$($md.BackupListCount)+"</td><td>"
        $s+=$($md.TargetFilesSize)+"</td><td>"
        $s+=$($md.TargetFilesCount)+"</td><td>"
        $s+=$($md.TargetSizeString)+"</td><td>"
        $s+=$($md.SourceFilesSize)+"</td><td>"
        $s+=$($md.SourceFilesCount)+"</td><td>"
        $s+=$($md.SourceSizeString)+"</td><td>"
        $s+=$(dateConvert $($md.LastBackupStarted))+"</td><td>"
        $s+=$(dateConvert $($md.LastBackupFinished))+"</td><td>"
        $s+=$($md.LastBackupDuration)+"</td></tr>"
        #Add-Content -Path $($file) $($s)
        $Content+=$s
    }
}
$Content+="</table>"
#$Content

sendMessage -subject "Duplicati backup info" -Content $($Content)
exit 0