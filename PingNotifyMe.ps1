 <#
.SYNOPSIS
    Simply ping nodes and email notificatin script.
.DESCRIPTION
    This Ping Notify Me Script reads from a csv file and checks to see if the IP Addresses can be reached from an ICMP ping or TCP Connect scan, if it cant ping the node then an email is sent with the specification of the computer and date/time stamp.

    The csv file needs the following headers in;
        Name
        Mac
        PCIP
        PCModel

.EXAMPLE
    Ping_IPs -ICMP -Path 'C:\IP Address.csv'
        Reads from the csv file and tries to ping each ip address with an ICMP ping scan.
.EXAMPLE
    Ping_IPs -TCPConnect -Path C:\IP Address.csv'
        Reads from the csv file and tries to ping each ip address with a TCP COnnect scan.
.PARAMETER ICMP
    uses ICMP echo reply to ping the node.
.PARAMETER TCPConnect
    Uses TCP connect to ping the node.
.PARAMETER Path
    Points to the csv file.
.LINK
    https://github.com/joer89/Logging.git
#>


function send0365Mail($Name, $Mac, $IPAddress, $PCModel){
   
    #The body of the html email is below.
    $htmlBody = "
        <html>
          <head><title></title></head>
          <body>
            <H1>Can't ping $IPAddress at $(Get-Date -format "dd-MMM-yyyy HH:mm")</H1>
            <br />
            <br />
            Name $Name
            <br />
            Mac Address $Mac
            <br />
            PC IP $IPAddress
            <br />
            PC Model $PCModel
            <br />
          </body>
        </html>"

        try{
            #Sends the email. 
            Send-MailMessage –From User@contoso.com –To User@contoso.com –Subject “Alert” –Body $htmlBody -BodyAsHtml -SmtpServer mail.messaging.smtpServer.contoso.com
            #Returns the message
            Return "EMail Message Sent."
        }
        catch{
            #Returns the message
            return "EMail Message Error"
        }
 
}

function PingNotifyMe{

[CmdletBinding(SupportsShouldProcess=$true)]        

    Param (        
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateScript({
            if(Test-Path $_){$true}else{Throw "Invalid path given: $_"}
            })]
        [string]$Path,
        [switch]$ICMP,
        [switch]$TCPConnect
        )

        Begin{
            if($Path){
               
                    Import-Csv $Path | ForEach-Object{
                         
                        #Stores the variables from each line of the csv file.                   
                        $Name = $_.Name          
                        $Mac = $_.Mac
                        $IPAddress = $_.PCIP
                        $PCModel = $_.PCModel

                        #ICMP Ping.
                        if($ICMP){
                            try{
                                Write-Host "`n<---------------ICMP Connect Scanning $IPAddress---------------"
                                #ICMP Ping with the IP Address.
                                $ping = Test-Connection $IPAddress -Count 1 -Quiet
                                if(-not($ping)){
                                    #Sends a email with the variables.
                                    send0365Mail($Name)($Mac)($IPAddress)($PCModel)
                                }
                                else{
                                    #Ping was successful, writes out on the screen.
                                    Write-Host "Ping $IPAddress Suceeded."
                                }                               
                            }
                            catch{
                                #Error occured with the ping.
                                Write-Host "Error occured when pinging $IPAddress"
                            } 
                            Write-Host "---------------$IPAddress--------------->"
                        }
                        elseif($TCPConnect){
                            try{
                                Write-Host "`n<---------------TCP Connct Scanning $IPAddress---------------"
                                #TCP Connect Scan with the IP Address.
                                $ping = Test-NetConnection -ComputerName $IPAddress -CommonTCPPort http -InformationLevel Quiet
                                if(-not($ping)){
                                    #Sends a email with the variables.
                                    send0365Mail($Name)($Mac)($IPAddress)($PCModel)
                                }
                                else{
                                    #Ping was successful, writes out on the screen.
                                    Write-Host "Ping $IPAddress Suceeded."
                                }                                
                            }
                            catch{
                                #Error occured with the ping.
                                Write-Host "Error occured when pinging $IPAddress"
                            }
                            Write-Host "---------------$IPAddress--------------->"
                        }              
                    }
            }
        }
        Process{}
        End{}
}
#PingNotifyMe -ICMP -Path C:\IPAddr.csv