
. c:\Scripts\Duplicati\DuplicatiTools.ps1

$global:login_pwd=<passphrase>
$global:Uri="http://localhost:8200/"
$global:session = $null


$global:headers =@{}
$global:headers.Add("User-Agent","Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko")
$global:headers.Add("Cache-Control","no-cache")
#$global:headers.Add("Connection","Keep-Alive")

$r=Invoke-WebRequest -Uri $global:Uri -Method GET -SessionVariable global:session -Headers $headers

$global:cookies=$session.Cookies.GetCookies($global:Uri)
#$cookies
$global:token = ""

foreach($c in $global:cookies){
    if ($c.Name -eq "xsrf-token") {
        $global:token=$c.Value
    }
}

$global:headers =@{}
$global:headers.Add("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
$global:headers.Add("Accept-Encoding", "gzip, deflate")
$global:headers.Add("Cookie",("xsrf-token="+$global:token))
$global:headers.Add("Cache-Control","no-cache")
$global:headers.Add("Accept","application/json, text/javascript, */*; q=0.01")
$global:headers.Add("User-Agent","Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko")
$global:headers.Add("X-Requested-With", "XMLHttpRequest")
$global:headers.Add("Referer",$($global:Uri+"login.html"))

$body = @{
 "get-nonce" = "1"
}

$r=Invoke-RestMethod -Uri $($global:Uri+$global:cmd.login) -Method POST -Body $body -Headers $global:headers -WebSession $global:session

$global:data=@{}
if ($r -match '"Status":.?"(\S+)"') {
    $global:data.Add("Status",$matches[1])
}
if ($r -match '"Nonce":.?"(\S+)"') {
    $global:data.Add("Nonce",$matches[1])
}
if ($r -match '"Salt":.?"(\S+)"') {
    $global:data.Add("Salt",$matches[1])
}

#$data

$global:cookies=$global:session.Cookies.GetCookies($global:Uri)
#$cookies
$global:token = ""

foreach($c in $global:cookies){
    if ($c.Name -eq "xsrf-token") {
        $global:token=$c.Value
    }
}

$global:headers =@{}
$global:headers.Add("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
$global:headers.Add("Accept-Encoding", "gzip, deflate")
$global:headers.Add("Cookie",("xsrf-token="+$global:token+"; session-nonce="+[uri]::EscapeDataString($global:data.Nonce)))
$global:headers.Add("Cache-Control","no-cache")
$global:headers.Add("Accept","application/json, text/javascript, */*; q=0.01")
$global:headers.Add("User-Agent","Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko")
$global:headers.Add("X-Requested-With", "XMLHttpRequest")
$global:headers.Add("Referer",$($global:Uri+"login.html"))

$s= BArray2Hex(Str2BArray($global:login_pwd))
#write-host "1. s ",$s
$s+=BArray2Hex([Convert]::FromBase64String($global:data.Salt))
#write-host "2. s ",$s
$saltedpwd = ComputeSHA256Hash0(Hex2BArray($s))
#write-host "saltedpwd ", $saltedpwd

$s1= BArray2Hex([Convert]::FromBase64String($global:data.Nonce))
#write-host "1. s1 ",$s1
$s1+= $saltedpwd
#write-host "2. s1 ",$s1
$noncepwd = ComputeSHA256Hash0(Hex2BArray($s1))
#$noncepwd
$noncepwd = Hex2BArray($noncepwd)
#$noncepwd
#write-host "noncepwd",([Convert]::ToBase64String($noncepwd))

$body=@{
    "password" =([string][Convert]::ToBase64String($noncepwd))
}

$r=Invoke-RestMethod -Uri ($global:Uri+$global:cmd.login) -Method POST -Body $body -Headers $global:headers -WebSession $global:session
if (!($r -match '"Status":.?"(\S+)"') -or ($matches[1] -ne "OK")) {
    write-host "Error login"
}

$global:cookies=$global:session.Cookies.GetCookies($global:Uri)
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
$global:headers.Add("X-XSRF-Token", $global:token)


$r=Invoke-WebRequest -Uri $global:Uri -Method GET -Headers $global:headers -WebSession $global:session
#$r
