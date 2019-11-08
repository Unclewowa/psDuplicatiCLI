#$global:headers=$null
#$global:cookies=$null
#$global:token=""
#$global:login_pwd=""
#$global:Uri=""
#$global:session=$null

. c:\Scripts\Duplicati\DuplicatiFunc.ps1
. c:\Scripts\Duplicati\DuplicatiLogin.ps1
. c:\Scripts\Duplicati\sendMSG.ps1

#$headers
#DuplicatiUpdateHeaders

$b = dGetBackups
#$b
#$b[0].Backup
#$b = dGetBackupByID1("4")
#$b.Backup
#$b.Schedule
#$Content="<p>"
foreach ($b1 in $b) {
    #write-host $b1.Backup
    $backup = $(dGetBackupByID1 $($b1.Backup.ID) )
    #$b1.Schedule
    #.Schedile
    #$backup.Filters[0]
    if ($backup.Metadata -ne $null) {
        $Content+=$("<b>"+$backup.ID+" "+$backup.Name+"</b><br/>")
        foreach ($md in $backup.Metadata) {
            $Content+= $($(ConvertTo-Json $md)+"<br/>")
#            $Content+= $($(ConvertTo-Json $backup.Metadata)+"<br/>")
#            $Content+= $($backup.Metadata.ToString()+"<br/>")
        }

#        foreach($md in $backup.Metadata) {
#            $backup.Metadata[$md]
#            $Content+= $(""+$md[0]+"<br/>")
#        }
    }
}
$Content+="</p>"
#$Content)
sendMassage $Content
