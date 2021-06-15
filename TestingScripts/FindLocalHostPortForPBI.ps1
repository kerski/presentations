#PLEASE OPEN YOUR POWER BI DESKTOP FILE BEFORE RUNNING THIS SCRIPT!!!!!

#Gets a list of teh ProcessIDs for all Open Power BI Desktop files
$processids = Get-Process msmdsrv | Select-Object -ExpandProperty id 
   
#Loops through each ProcessIDs, gets the diagnostic port for each file, and finally generates the connection that can be use when connecting to the Vertipaq model.
if($processids)
{
    foreach($processid in $processids)
    {
        $pbidiagnosticport = Get-NetTCPConnection | ? {($_.State -eq "Listen") -and ($_.RemoteAddress -eq "0.0.0.0") -and ($_.OwningProcess -eq $processid)} | Select-Object -ExpandProperty LocalPort

        Write-Host "Enter this into the tool of your choice -- localhost:$pbidiagnosticport" -ForegroundColor Green
    } 
}
else
{
    Write-Host "Please open a Power BI File!" -ForegroundColor Red
}