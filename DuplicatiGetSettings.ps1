$global:headers=$null
$global:cookies=$null
$global:token=""
$global:login_pwd=""
$global:Uri=""
$global:session=$null

. c:\Scripts\Duplicati\DuplicatiFunc.ps1
. c:\Scripts\Duplicati\DuplicatiLogin.ps1

#$headers
#DuplicatiUpdateHeaders

$b = dGetSettings
$b
