#Checks to see if the file exists if not it prompts for the password and creates a file with the encrypted password.
function StoreCreds{

        if((-Not (Test-Path -LiteralPath "C:\O365\O365User.txt")) -or (-Not (Test-Path -LiteralPath "C:\O365\O365Pass.txt"))){   
        
            #Checks to see if C:\O365 folder is there otherwise creates it.        
            if(-Not (Test-Path -LiteralPath "C:\O365")){
                #Creates the folder
                New-Item -Path "C:\" -Name "O365" -ItemType directory
            }
            #Gets the credentials.
            $Credentials = Get-Credential 
            #Stores the office365 credentials to a text file.
            $Credentials.UserName | Set-Content "C:\O365\O365User.txt"
            #Stores the office365 credentials to a text file.
            $Credentials.Password | ConvertFrom-SecureString | Set-Content "C:\O365\O365Pass.txt"
        }
   
}#end function.

#Decodes the password stored in pass.txt, uses the password for authentication to Office365 and sends the message.
function send0365Mail{

        #Checks to see if both the user and password files are there.
       if((Test-Path -LiteralPath "C:\O365\O365User.txt") -and (Test-Path -LiteralPath "C:\O365\O365Pass.txt")){ 

            #Gets the Office365 credentials.
            $User = Get-Content "C:\O365\O365User.txt"
              
            #Gets the Office365 credentials.
            $Pass = Get-Content "C:\O365\O365Pass.txt" | ConvertTo-SecureString

            #Adds the username and password together and puts it in the Credentials variable.
            $credential = New-Object System.Management.Automation.Pscredential -Argumentlist $User, $Pass
                    
            try{
                #Sends the email.
                Send-MailMessage -Credential $credential –From user@Office365domain.com –To user@Office365domain.com –Subject “Test Email” –Body $body -SmtpServer smtp.office365.com -Port 587 -UseSsl
                #Writes out to the screen.
                Write-Host "Message Sent."
            }
            catch{
                #Writes out to the screen.
                Write-Error "Message error."
            }#end try.
    }
    else{
            #Creates the credentials for office365.
            StoreCreds
        }#End if.

}#end function.