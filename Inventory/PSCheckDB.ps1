<#
.Synopsis
Small Description
	- This script queries the SQL Database and imports the WMI Queries found on the local machine.
Description.
	- This script has been tested with Microsoft SQL Server 2012 and Windows 2012R2/10.
	- This script is designed to be implemented with Group Policy.
	- Once the script runs on the client machine, it will report back to the SQL Database and edit if necessary.
	- There are Three functions, queryComputer, ComputerPurchased and connectReadEditSQL.
	- The only thing that needs editing to suit you is the Connection String to the SQL Database and ComputerPurchased function.
.Notes
   Author: Joe Richards
   Date:   06/Feb/2017
.LINK
  https://github.com/joer89/Logging/Inventory
#>

#Different SQL query Strings.
$sqlQuerySelectAll = "SELECT * FROM tblDevices"
$sqlQueryUpdateRow = "UPDATE tblDevices SET OwnerName='$($usrName)', ComputerName='$($ComName)', Make='$($ComMake)', Model='$($ComModel)', Processor='$($ComProcessor)', DiskModel='$($DiskModel)', DiskSize='$($ComDiskSize)', RAM='$($ComRam)', Purchased='$($CompPurchased)', LastUpdated='$($CurDateTime)' WHERE SerialNumber='$($SNNumber)';"
$sqlQueryInsertSNRow = "INSERT INTO tblDevices(OwnerName, ComputerName, SerialNumber, Make, Model, Processor, DiskModel, DiskSize, RAM, Purchased, LastUpdated) values('$($usrName)','$($ComName)','$($SNNumber)','$($ComMake)','$($ComModel)','$($ComProcessor)','$($DiskModel)','$($ComDiskSize)','$($ComRam)','$($CompPurchased)','$($CurDateTime)');"

#Booleon variable to update or insert a row to the SQL Database.
[Bool]$Script:hasRow

#Retrieves the WMI queries.
function queryComputer{
    
       #Displays the Username
        $script:usrName = $env:USERNAME

        #Displays the Computer Name.
        $script:ComName = $env:ComputerName
        
         #Displays the bios serial number.
        $querySerialNumber = "win32_bios"
        $script:SNNumber = Get-WmiObject $querySerialNumber | Format-Table -HideTableHeaders SerialNumber | Out-String

        #Displays the Make of the Computer.
        $queryMake = "Win32_ComputerSystem"  
        $script:ComMake = Get-WmiObject $queryMake | Format-Table -HideTableHeaders  Manufacturer | Out-String

        #Displays the Model of the Computer.
        $queryModel = "Win32_ComputerSystem"
        $script:ComModel = Get-WmiObject $queryModel  | Format-Table -HideTableHeaders Model | Out-String

        #Displays the processor Name.
        $queryProcessorName = "win32_processor"
        $script:ComProcessor = Get-WmiObject $queryProcessorName  | Format-Table -HideTableHeaders Name | Out-String

        #Displays the SSD/HDD Model.
        $QueryDiskModel = "win32_DiskDrive"
        $Script:DiskModel = Get-WmiObject $QueryDiskModel | Format-Table -HideTableHeaders Model | Out-String

        #Displays C Drive size
        $queryDiskCSize = "win32_logicaldisk"
        $script:ComDiskSize = Get-WmiObject $queryDiskCSize -Filter "DeviceID='C:'" | Format-Table -HideTableHeaders Size | Out-String

        #Displays the RAM Size.
        $queryRAM = "Win32_ComputerSystem"
        $script:ComRam = Get-WmiObject $queryRAM |  Format-Table -HideTableHeaders TotalPhysicalMemory  | Out-String

        #Get the current date and time.
        $script:CurDateTime = Get-Date  | Out-String
}#End Function.

#Checks the Computer model and returns a manually entered purchase date.
function ComputerPurchased{
        if($ComModel -match "Latitude E6420"){
            $script:CompPurchased = "2014" | Out-String
        }
        else{
            $script:CompPurchased = "Unknown" | Out-String
        }#end if
}#end function.

#Stops truncation error messages (When the WMI Query length exceeds the SQL cell length.)
function checkVarLength{

    #Replaces all the spaces which may occure during the WMI retrieval.
    $Script:usrName.Replace(' ','')
    $Script:ComName.Replace(' ','')
    $Script:SNNumber.Replace(' ','')
    $Script:ComMake.Replace(' ','')
    $Script:ComModel.Replace(' ','')
    $Script:ComProcessor.Replace(' ','')
    $Script:DiskModel.Replace(' ','')
    $Script:ComDiskSize.Replace(' ','')
    $Script:ComRam.Replace(' ','')
    $Script:CompPurchased.Replace(' ','')

    #Checks each veriable to see if its over or equal to a hundred characters in length.
    if($Script:usrName.Length -ge 100){
        $script:usrName = "Unusual Length"
    }
    if($Script:ComName.Length -ge 100){
        $Script:ComName = "Unusual Length"
    }
    if($Script:SNNumber.Length -ge 100){
        $Script:SNNumber = "Unusual Length"
    }
    if($Script:ComMake.Length -ge 100){
        $Script:ComMake = "Unusual Length"
    }
    if($Script:ComModel.Length -ge 100){
        $Script:ComModel = "Unusual Length"
    }
    if($Script:ComProcessor.Length -ge 100){
        $Script:ComProcessor = "Unusual Length"
    }
    if($Script:DiskModel.Length -ge 100){
        $Script:DiskModel = "Unusual Length"
    }
    if($Script:ComDiskSize.Length -ge 100){
        $Script:ComDiskSize = "Unusual Length"
    }
    if($Script:ComRam.Length -ge 100){
        $Script:ComRam = "Unusual Length"
    }
    if($Script:CompPurchased.Length -ge 100){
        $Script:CompPurchased = "Unusual Length"
    }
}#end function.

#Connect, reads and updates the SQL database.
function connectReadEditSQL{
    #Creates the connection to SQL.
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "SERVER=localhost; Database=INVENTORY; USER Id=sa; Password=sa;"
    $conn.Open()
    #Creates the command for the connection to SQL.
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $conn
    #Queries everything from the database.
    $cmd.CommandText = $sqlQuerySelectAll
    #Reads the Data from the database.
    $result = $cmd.ExecuteReader()
    #Reads the results from the SQL Database.
    while($result.Read()){
        #Checks to see if the serial number is already in the database and $hasRow returnes true if found.
        if($result.GetValue(3) -match $($SNNumber)){
            $hasRow = $true
            Write-Host "SN is $($SNNumber), updating the database."
        }
        else{
            $hasRow = $false
        }
    }
    #Close the reader.
    $result.Close()
    if($hasRow){ 
        #Updates the row.
        $cmd.CommandText = $sqlQueryUpdateRow
        $cmd.ExecuteNonQuery()
    }
    else{
        #Adds a new row.
        $cmd.CommandText = $sqlQueryInsertSNRow
        $cmd.ExecuteNonQuery()
    }#end if
    #Close the SQL Connection.
    $conn.Close()
}#end function.

#Runs the functions.
queryComputer
ComputerPurchased
checkVarLength
connectReadEditSQL