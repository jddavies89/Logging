#Start function
#Imports the log.psm1 module.
function importModule{
    #Start the try catch statement to load the module log.psm1.
    try{  
        #Imports the module and stops th program if it does not exist.
        Import-Module ".\AdvancedLoggerModule.psm1" -ErrorAction Stop -DisableNameChecking
        #Display activity.
        Write-host "The module has loaded." -ForegroundColor "Magenta"  
    }
    catch{
        #Display an error.
        Write-Host "The module has failed." -ForegroundColor red
        #Waits for a key press to and closes.
        [Console]::ReadKey()
    }#End try catch statement.

}#End function

#Runs the function to import the logging module.
importModule

try{

    #Logs to C:\logging\logger.log with the text This text was added to C:\logging\logger.log.
    Log-ToFile -Path C:\logging -fileName logger.log -SimpleLogging -Text "This text was added to C:\logging\logger.log"
    Write-Host "Added to the log file." -ForegroundColor "Magenta"
}
catch{
    Write-Host "Failed to wirte to the log file." -ForegroundColor Red
}