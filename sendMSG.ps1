function sendMessage($subject, $Content) {
    #Set Up Variables for Sending Mail 
    $smtpServer = "smtp.mailserver.com" 
    $compName= ${env:COMPUTERNAME}
    if ($subject -eq "" ) {
        $subject =  $compName + " backup info"
    }
    $sendFrom = "from.address@domain.com" 
    $sendTo = "to.address@domain.com"
    $pass = "password"
    $port = "999"
    
    $StartEmailLayout = @" 
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"> 
    <html><head><title>My Systems Report</title> 
 
    <!-- 
    body { 
    font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; 
    } 
 
    #report { width: 835px; } 
 
    table{ 
    border-collapse: collapse; 
    border: none; 
    font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif; 
    color: black; 
    margin-bottom: 10px; 
    } 
 
    table td{ 
    font-size: 12px; 
    padding-left: 0px; 
    padding-right: 20px; 
    text-align: left; 
    } 
 
    table th { 
    font-size: 12px; 
    font-weight: bold; 
    padding-left: 0px; 
    padding-right: 20px; 
    text-align: left; 
    } 
 
    h2{ clear: both; font-size: 130%; } 
 
    h3{ 
    clear: both; 
    font-size: 115%; 
    margin-left: 20px; 
    margin-top: 30px; 
    } 
 
    p{ margin-left: 20px; font-size: 12px; } 
 
    table.list{ float: left; } 
 
    table.list td:nth-child(1){ 
    font-weight: bold; 
    border-right: 1px grey solid; 
    text-align: right; 
    } 
 
    table.list td:nth-child(2){ padding-left: 7px; } 
    table tr:nth-child(even) td:nth-child(even){ background: #CCCCCC; } 
    table tr:nth-child(odd) td:nth-child(odd){ background: #F2F2F2; } 
    table tr:nth-child(even) td:nth-child(odd){ background: #DDDDDD; } 
    table tr:nth-child(odd) td:nth-child(even){ background: #E5E5E5; } 
    div.column { width: 320px; float: left; } 
    div.first{ padding-right: 20px; border-right: 1px  grey solid; } 
    div.second{ margin-left: 30px; } 
    table{ margin-left: 20px; } 
    --> 
 
    </head> 
    <body> 
"@
     
    # Setup Mail Format 
    $EndEmailLayout = @" 
    </div> 
    </body> 
    </html> 
"@        
 
    # Assemble the final report from all our HTML sections 
    #$Content = $StartEmailLayout + $Content1 + $EventInfo + $EndEmailLayout 
    #body
    $emailMessage = New-Object System.Net.Mail.MailMessage( $sendFrom , $sendTo )
    $emailMessage.Subject = $subject
    $emailMessage.IsBodyHtml = $true
    #$Content
#    $HtmlContent = $Content  | ConvertTo-Html -Fragment -PreContent '<h2>E,F disks backup info</h2>' | Out-String
#    $HtmlContent
    $emailMessage.Body = $StartEmailLayout + $Content + $EndEmailLayout
    #client
    $SMTPClient = New-Object Net.Mail.SmtpClient($smtpServer, $port) 
    $SMTPClient.EnableSsl = $true

    $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($sendFrom, $pass)
    $SMTPClient.Send($EmailMessage)
}