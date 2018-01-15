<#
.Synopsis
   This Advanced function sends Office365 emails for logging through anonymous mail server.
.DESCRIPTION
    -Nothing has to be changed for this to work except your smtpServer.
.Notes
   Author: Joe Richards
   Date: 15/Jan/2018
.LINK
  https://github.com/joer89/Logging
#>
#Start of function
function sendO365Mail{

[CmdletBinding(SupportsShouldProcess=$true)]        

    Param (        
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string]$From,
         [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=1)]
        [string]$To,
         [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=2)]
        [string]$Subject,
         [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=3)]
        [string]$body

         )

            #Sends the email.
            Send-MailMessage –From $From –To $To –Subject $Subject –Body $body -BodyAsHtml -SmtpServer mail.contoso.com
            #Writes out to the screen.
            Write-Host "Message Sent."
}#End function