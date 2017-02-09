<#
.Synopsis
	- This script inserts the current loggon on user's Username, computername and date & time to the SQL Database.
.Description.
	- This script is designed to be implemented with Group Policy under logon.
	- Once the script runs on the client machine, it will insert the data to the SQL Database.
	- The only thing that needs editing to suit you is the Connection String to the SQL Database.
.Notes
   Author: Joe Richards
   Date:   08/Feb/2017
.LINK
  https://github.com/joer89/Logging/Log_UserLogins
#>

#SQL query String to insert the information to the database..
$sqlQueryInsertSNRow = "INSERT INTO tblUserLogins(Username, ComputerName, LoggedIn) values('$($usrName)','$($ComName)','$($CurDateTime)');"

#Retrieves the username, computername and date.
function logUser_Logon{
    
        #Displays the Username
        $script:usrName = $env:USERNAME

        #Displays the Computer Name.
        $script:ComName = $env:ComputerName 

        #Get the current date and time.
        $script:CurDateTime = Get-Date  | Out-String

}#End Function.

#Stops truncation error messages (When the WMI Query length exceeds the SQL cell length.)
function checkVarLength{

    #Replaces all the spaces which may occure during the WMI retrieval.
    $Script:usrName.Replace(' ','')
    $Script:ComName.Replace(' ','')


    #Checks each veriable to see if its over or equal to a hundred characters in length.
    if($Script:usrName.Length -ge 100){
        $script:usrName = "Unusual Length"
    }
    if($Script:ComName.Length -ge 100){
        $Script:ComName = "Unusual Length"
    }
}#end function.

#Connect and insert data to the SQL database.
function connectReadEditSQL{
    #Creates the connection to SQL.
    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = "SERVER=IPAddress,1433; Database=User_Logins; USER Id=sa; Password=sa;"
    $conn.Open()
    #Creates the command for the connection to SQL.
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $conn
    #Queries everything from the database.
    $cmd.CommandText = $sqlQueryInsertSNRow
    $cmd.ExecuteNonQuery()
    $conn.Close()
}#end function.


cls
#Runs the functions.
logUser_Logon
checkVarLength
connectReadEditSQL
