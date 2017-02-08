############################################################
##
##Author by Joe Richards
##
##This is a simple logging app example with capabilities to 
##          *Log at startup. 
##          *Log on close.
##          *Delete the log.
##          *Check the log file.
##          *Open the log file.
##          *Add text to the log on user input. 
##          *Logs if the module has been loaded. 
##
##############################################################


#Stores the log file name.
param(
    #Retrives the execution directory.
    $path = (split-path $script:MyInvocation.MyCommand.Path -parent),
    #Stores the module file.
    $file = "\log.psm1",
    #Stores the exection directory and the module file.
    $moduleDir = ($path + $file),
    #Stores the name for get-module if statement.
    $fileName = "log"
)

#Start function
#Checks the file and creates if it does not exist.
function start-App{
        try{
            #Clears the screen.
            cls
            #Displays activity.
            Write-Host "Writting to log."  -ForeGroundColor "Magenta"
            #Write to log from the module on startup.
            startApp
        }
        catch{
            #Display activity on error.
            Write-Host "Cant write to log." -ForeGroundColor red
        }
        Finally{
            #When finished, opens the menu.
            menu
        }
}#End function

#Start function
#Active the app is closed.
function close-App{
    try{ 
        #Clears the screen.
        cls
        #Writes to log from the module when closing the app.
        closeApp  
    }
    catch{
        #Display activity on error.
        Write-Host "Failed to finish the log session." -ForeGroundColor red
    }
    Finally{
        #Closes the application.
        Exit
    }
}#End function

#Start function
#Deletes the log file.
function del-log{
    try{
            #Clears the screen.
            cls
            #Displays activity.
            Write-Host "Attempting to delete the log file." -ForeGroundColor "Magenta"
            #Deletes the log file from the module.
            delFile 
            #Displays activity.
            Write-Host "Deleted the log file."  -ForeGroundColor "Magenta"
        }
        catch{
            #Display activity on error.
            Write-Host "Could not delete log file, log.log."  -ForeGroundColor red
        }
        Finally{
            #Displays the menu.
            menu
        }
}#End function

#Start function
#Check if the log file exist.
function check-File{
    try{
            #Clears the screen.
            cls
            #Displays activity.
            Write-Host "Checking the log file." -ForeGroundColor "Magenta"
            #checks the log file and creates it if it exists from the module.
            checkFile 
            #Display activity.
            Write-Host "Checked the log file."  -ForeGroundColor "Magenta" 
        }
        catch{
            #Display an error.
            Write-Host "Could not check the log file."  -ForeGroundColor red
        }
        Finally{
            #Display the menu
            menu
        }
}#End function

#Start function
#Adds to the log file.
function add-Log{
   try{
        #Clears the screen.
        cls
        #Writes text to the log file from the user input.
        $text = Read-Host "Add text to the log file."
        #Display acitivty.
        Write-Host "Adding text to the file."  -ForeGroundColor "Magenta"
        #Adds the text to the log file.
        addlog $text
        #Display activity.
        Write-Host "Added text to the log file."  -ForeGroundColor "Magenta"
    }
    catch{
        #Display an error.
         Write-Host "Couldn't append text to log.log."  -ForeGroundColor red
    }
    Finally{
        #Displays the menu.
        menu
    }
}#End function.

#Start function
#Opens the log file.
function open-Log{
    try{
        #Clears the screen.
        cls
        #Display activity.
        Write-Host "Attempting to open log file." -ForegroundColor "Magenta"  
        #Opens the logfile from the module.  
        openlog 
        #Display activity.
        Write-Host "Opened the log file." -ForegroundColor "Magenta"  
      }
    catch{
        #Display an error.
        Write-Host "Failed to open the log file." -ForegroundColor red
    }
    Finally{
        #Display the menu.
        menu
    }
}#End function.

#Start function
#Main menu options.
function menu{
    #Stores the choice of the users input.
    [int]$choice = 0;
    #loop until key press from 1 to 5.
    while ( $choice -lt 1 -or $choice -gt 5 ){
        Write-Host "1. Delete log."
        Write-Host "2. Check the path"
        Write-Host "3. Add to log."
        Write-Host "4. Opens the log file."        
        Write-Host "5. Exit application"
        #Stores the choice.
        $choice = Read-Host "Which option would you like to do"
        #opens the necessary
        switch($choice){
            1{del-log}
            2{check-File}
            3{add-Log}
            4{open-Log}
            5{close-App}
        }
    }
}#End function

#Start function
#Imports the log.psm1 module.
function importModule{
    #Start the try catch statement to load the module log.psm1.
    try{  
        #Imports the module and stops th program if it does not exist.
        Import-Module $moduleDir -ErrorAction Stop -DisableNameChecking
        #Display activity.
        Write-host "The module has loaded." -ForegroundColor "Magenta"  
    }
    catch{
        #Display an error.
        Write-Host "The module has failed." -ForegroundColor red
        #Waits for a key press to and closes.
        [Console]::ReadKey()
    }#End try catch statement.

    #process the module is loaded, otherwise the module is is not loaded and the try catch will stop the program.
    if(Get-Module $fileName){    
        #Logs the module activity.
        loadModuleLog
        #Start the application and log activities.
        start-App
    }
}#End function

#App start.
importModule