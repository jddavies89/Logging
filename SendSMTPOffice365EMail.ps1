
<#
.Synopsis
    This script sends SMTP Office365 email.
.DESCRIPTION
    There is three functions, encryptPassword function is for encrpyting a password in base64 and saving to C:\pass.txt, decryptPassword function decryptes the password and duisplays on screen, the send0365Mail password sends the email with the encrypted password and the username selected within the function.
.LINK
    https://github.com/joer89/Logging
#>

function encryptPassword{

    $credPass = Read-Host "Password for Office365: "
    #convert the user and password to bytes.
    $BytesPass = [System.Text.Encoding]::Unicode.GetBytes($credPass)

    #Encode the bytes to Base64.
    $EncodedPass = [Convert]::ToBase64String($BytesPass)

    #Write two lines of the encoded text toi a file.
    $EncodedPass | Out-File "C:\Pass.txt"

    #Displays the Main Menu.
    main;
}

function decryptPassword{
    #Reads the first line of the encrypted file.
    $Encodeduser = Get-Content -Path "C:\Pass.txt" | select -Index 0

    #Decryptes the line.
    $DecodedPass = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedPass))
    
    #Displays the line out on the screen.
    $DecodedPass

    #Displays the Main Menu.
    main;
}

function send0365Mail{

    #Reads the first line of the encrypted file.
    $EncodedPass = Get-Content -Path "C:\Pass.txt" | select -Index 0

    #Decryptes the line.
    $DecodedPass = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedPass))

    #username of the credentials to login to office365.
    $login = "username@domain.com"
    #Converts the decrypted text to $password variable with a secure string.
    $password = $DecodedPass | Convertto-SecureString -AsPlainText -Force
    $credentials = New-Object System.Management.Automation.Pscredential -Argumentlist $login,$password
    try{
        #Sends the email.
        Send-MailMessage -Credential $credentials –From joe.richards@theregisschool.co.uk –To joe.richards@theregisschool.co.uk –Subject “Test Email” –Body “Test” -SmtpServer smtp.office365.com -Port 587 -UseSsl
        Write-Host "Message Sent."
    }
    catch{
        Write-Error "Message error."
    }
    #Displays the Main Menu.
    main;
} 

#Main Menu Function.
function main {
    #Main menu choice.
    Write-Host "1. Encrypt password."
    Write-Host "2. Decryptes password."
    Write-Host "3. send 0365eMail with encrypted password."
    #Users Choice, input of numeric value.
    $input = Read-Host "Please make a numeric choice."
    #Start of te switch statement to implement the functions.
    Switch($input){
        '1'{
                #Clears the screen and goes to the function.
                cls
                encryptPassword
                }
        '2'{
                #Clears the screen and goes to the function.
                cls
                decryptPassword
                }
        '3'{
                #Clears the screen and goes to the function.
                cls
                send0365Mail
                }
    }#End Switch
}#End Function.

#Clears the screen.
cls
#Displays the Main Menu.
main;