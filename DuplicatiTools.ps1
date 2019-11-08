#
function Format-HumanReadable {
    param ($size)
    switch ($size) {
        {$_ -ge 1PB}{"{0:n2}Pb" -f ($size / 1PB); Break}
        {$_ -ge 1TB}{"{0:n2}Tb" -f ($size / 1TB); Break}
        {$_ -ge 1GB}{"{0:n2}Gb" -f ($size / 1GB); Break}
        {$_ -ge 1MB}{"{0:n2}Mb" -f ($size / 1MB); Break}
        {$_ -ge 1KB}{"{0:n2}Kb" -f ($size / 1KB); Break}
        default {"{0}" -f ($size) + "B"}
    }
}

#
Function Format-HumanReadable1 {
    param ($size)
    switch ($size) {
        {$_ -ge 1PB}{"{0:#'PB'}" -f ($size / 1PB); Break}
        {$_ -ge 1TB}{"{0:#'TB'}" -f ($size / 1TB); Break}
        {$_ -ge 1GB}{"{0:#'GB'}" -f ($size / 1GB); Break}
        {$_ -ge 1MB}{"{0:#'MB'}" -f ($size / 1MB); Break}
        {$_ -ge 1KB}{"{0:#'KB'}" -f ($size / 1KB); Break}
        default {"{0}" -f ($size) + "B"}
    }
}

function Hex2BArray {
    Param (
        [Parameter(Mandatory=$true)]
        [string]
        $string1
    )

    ($string1 -split '([a-f0-9]{2})' | foreach-object { if ($_) {[System.Convert]::ToByte($_,16)}})
}

function BArray2Hex {
    Param (
        [Parameter(Mandatory=$true)]
        [byte[]]
        $data1
    )
    
    [String]::Join("", ($data1 | % { "{0:x2}" -f $_}))
}

function BArray2Str {
    Param (
        [Parameter(Mandatory=$true)]
        [byte[]]
        $data1
    )
    
    [System.Text.Encoding]::UTF8.GetString($data1)
#    [System.BitConverter]::ToString($data1)
}

function Str2BArray {
    Param (
        [Parameter(Mandatory=$true)]
        [string]
        $string1
    )

    [system.Text.Encoding]::UTF8.GetBytes($string1)
}

function ComputeSHA256Hash0 {
    Param (
        [Parameter(Mandatory=$true)]
        [byte[]]
        $data1
    )

    $hasher = [System.Security.Cryptography.HashAlgorithm]::Create('sha256')
    $hash = $hasher.ComputeHash($data1)
    $hashString = [System.BitConverter]::ToString($hash)
    $hashString.Replace('-', '')
}
function dateConvert($d){
#"20190827T151308Z"
    $date=@{}
    #$date=$( Get-Date $d -Format 'YYYMMDDTHHmmssZ' )
    #$date=[datetime]::ParseExact($($d),'yyyyMMddTHHmmssZ',$null)
#    $date=[datetime]::ParseExact($($d),'o',$null)
    #$d
    $date[0]=$d.Substring(0,4)
    $date[1]=$d.Substring(4,2)
    $date[2]=$d.Substring(6,2)
    $date[3]=$d.Substring(9,2)
    $date[4]=$d.Substring(11,2)
    $date[5]=$d.Substring(13,2)

    $(""+$date[2]+"."+$date[1]+"."+$date[0]+" "+$date[3]+":"+$date[4]+":") 
#    #$(""+$date.Year+"."+$date[1]+"."+$date[0]+" "+$date[3]+":"+$date[4]+":") 
}
