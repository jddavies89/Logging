<#
.Synopsis
   This Module sends Office365 emails for logging.
.DESCRIPTION
   - There is two functions for this module, StoreCred and send0365Mail.
   - The StoreCreds checks to see if the folder and files exist for authenticating to Office365 and if it doesnt exist, then stores the credentials to C:\o365\.
   - The SendO354Mail function retrieves the files which were created with StoreCreds function and sends the Email to Office365 email address.
   - Nothing has to be changed for this to work except under Send-MailMessage, the -To and the -From.
.Notes
   Author: Joe Richards
   Date: 02/Feb/2017
.LINK
  https://github.com/joer89/Logging
#>

#Checks the last creation time of the folder, this is so we dont get authentication issue over 24 hours.
function checkFolder{

    #Check the accessed time on the folder.
    $lastwritetime = (Get-Item "C:\O365").LastAccessTime
    #Adds one day.
    $timeSpan = New-TimeSpan -Day 1
    #Gets the current time.
    $currentTime = Get-Date
    
    #If the date is within the last day of the creation time of the folder sends the email otherwise prompts for the credentials.
    if(!($currentTime -le ($lastwritetime + $timeSpan))){
        StoreCreds
    }
}

#Checks to see if the file exists if not it prompts for the password and creates a file with the encrypted password.
function StoreCreds{

        if((-Not (Test-Path -LiteralPath "C:\O365\O365User.txt")) -or (-Not (Test-Path -LiteralPath "C:\O365\O365Pass.txt"))){   
        
            #Checks to see if C:\O365 folder is there otherwise creates it.        
            if(-Not (Test-Path -LiteralPath "C:\O365")){
                #Creates the folder
                New-Item -Path "C:\" -Name "O365" -ItemType directory
            }
            #Gets the credentials.
            $Credentials = Get-Credential -Message "Office 365 Authentication for SMTP."
            #Stores the office365 credentials to a text file.
            $Credentials.UserName | Set-Content "C:\O365\O365User.txt"
            #Stores the office365 credentials to a text file.
            $Credentials.Password | ConvertFrom-SecureString | Set-Content "C:\O365\O365Pass.txt"
        }
   
}#end function.

#Reads the User and Password text files for authentication to Office365 and sends the message.
function send0365Mail{

       #Checks the creation time of the O365 folder, this is to prevent the authentication issue within 24 hours.
       checkFolder

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
