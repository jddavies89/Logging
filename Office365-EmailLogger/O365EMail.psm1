<#
.Synopsis
   This Module sends Office365 emails for logging.
.DESCRIPTION
   There is three functions for this module, encryptPassword, decryptPassword and send0365Mail.
   This module sends Office365 Emails and the Logger.ps1 script changes the body content of the email.
.PARAMETER credPass
    Stores the Authentication Password for Office365 if C:\Pass.txt doesnt exist, it also encodes it to base64.
.PARAMETER login
    Stores the username Authentication for Office365, this will need to be changed to suite you.
.PARAMETER Send-MailMessage
    There has to be a few changes here;
        -To and -From
.LINK
  https://github.com/joer89/Logging
#>

#Checks to see if the file exists if not it prompts for the password and creates a file with the encrypted password.
function encryptPassword{
    #If the file doesnt exit, prompts otherwise reads from C:\Pass.txt.
    if(test-path "C:\Pass.txt"){}else{
        #Prompts for the Office365 authentication password.
        $credPass = Read-Host "Password for Office365: "
        #convert the user and password to bytes.
        $BytesPass = [System.Text.Encoding]::Unicode.GetBytes($credPass)

        #Encode the bytes to Base64.
        $EncodedPass = [Convert]::ToBase64String($BytesPass)

        #Write two lines of the encoded text toi a file.
        $EncodedPass | Out-File "C:\Pass.txt"
    }#end if.
}#end function.

#decodes the password from the pass.txt file.
function decryptPassword{
    #Reads the first line of the encrypted file.
    $Encodeduser = Get-Content -Path "C:\Pass.txt" | select -Index 0

    #Decryptes the line.
    $DecodedPass = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedPass))
    
    #Displays the line out on the screen.
    Write-host "The Office365 password is $DecodedPass."
}# end function.


#Decodes the password stores in pass.txt, uses the password for authentication to Office365 and sends the message.
function send0365Mail{

    #Reads the first line of the encrypted file.
    $EncodedPass = Get-Content -Path "C:\Pass.txt" | select -Index 0
    #Decryptes the line.
    $DecodedPass = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedPass))

    #username of the credentials to login to office365.
    $login = "Office365Email@Domain.com"
    #Converts the decrypted text to $password variable with a secure string.
    $password = $DecodedPass | Convertto-SecureString -AsPlainText -Force
    #Adds the username and password together and puts it in Credentials variable.
    $credentials = New-Object System.Management.Automation.Pscredential -Argumentlist $login,$password
    
    try{
        #Sends the email.
        Send-MailMessage -Credential $credentials –From Office365Email@Domain.com –To Email@Domain.com –Subject “O365 Script” –Body $body -SmtpServer smtp.office365.com -Port 587 -UseSsl
        #Writes out to the screen.
        Write-Host "Message Sent."
    }
    catch{
        #Writes out to the screen.
        Write-Error "Message error."
    }# end try.
}#end function.
