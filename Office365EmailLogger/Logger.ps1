param(
    #Retrives the execution directory and Stores the content of $body.
    $path = (split-path $script:MyInvocation.MyCommand.Path -parent),
    $body
)#end paramter.

#imports the module.
function ImpModule{
    #Imports the O365Logger module.
    Import-Module  $path\O365EMail.psm1
}#end function.


#Imports the office365 logger module from ImpModule function.
ImpModule


#Stores the body content of the emails.
$body = "This script started at $(Get-Date -format "dd-MMM-yyyy HH:mm")"

#Sends the Office365 email with the body content.
send0365Mail $body
