<#
    Author: John Kerski
    Description: This script creates Build and Development workspaces in Power BI, assigns the service user
    and assigns to the Premium Per User capacity to the two workspaces. 

    Dependencies: Service User must be created beforehand and you must have Power BI Tenant rights.
#>
#Install Powershell Module if Needed
if (Get-Module -ListAvailable -Name "MicrosoftPowerBIMgmt") {
    Write-Host "MicrosoftPowerBIMgmt installed moving forward"
} else {
    #Install Power BI Module
    Install-Module -Name MicrosoftPowerBIMgmt
}

#Set Variables
$BuildWSName = "Build"
$BuildDesc = "Used to test Power BI Reports before moving to development workspaces"
$DevWSName = "Dev"
$DevDesc = "Development environment for Power BI Reports"
$SvcUser = "{USERNAME}"

#Login into Power BI to Create Workspaces and az login
Login-PowerBI

#Get Premium Per User Capacity as it will be used to assign to new workspace
$Cap = Get-PowerBICapacity -Scope Individual

if(!$Cap.DisplayName -like "Premium Per User*")
{
    Throw "Script expects Premium Per Use Capacity."
}

#Create Build Workspace
New-PowerBIWorkspace -Name $BuildWSName

#Find Workspace and make sure it wasn't deleted (if it's old or you ran this script in the past)
$BuildWSObj = Get-PowerBIWorkspace -Scope Organization -Filter "name eq '$($BuildWSName)' and state ne 'Deleted'"

if($BuildWSObj.Length -eq 0)
{
  Throw "$($BuildWSName) workspace was not created."
}

#Update properties
Set-PowerBIWorkspace -Description $BuildDesc -Scope Organization -Id $BuildWSObj.Id.Guid
Set-PowerBIWorkspace -CapacityId $Cap.Id.Guid -Scope Organization -Id $BuildWSObj.Id.Guid 

#Assign service account admin rights to this workspace
Add-PowerBIWorkspaceUser -Id $BuildWSObj[$BuildWSObj.Length-1].Id.ToString() -AccessRight Admin -UserPrincipalName $SvcUser

#Create Dev Workspace
New-PowerBIWorkspace -Name $DevWSName

#Find Workspace and make sure it wasn't deleted (if it's old or you ran this script in the past)
$DevWSObj = Get-PowerBIWorkspace -Scope Organization -Filter "name eq '$($DevWSName)' and state ne 'Deleted'"

if($DevWSObj.Length -eq 0)
{
  Throw "$($DevWSName) workspace was not created."
}

#Update properties
Set-PowerBIWorkspace -Description $DevDesc -Scope Organization -Id $DevWSObj.Id.Guid
Set-PowerBIWorkspace -CapacityId $Cap.Id.Guid -Scope Organization -Id $DevWSObj.Id.Guid 

#Assign service account admin rights to this workspace
Add-PowerBIWorkspaceUser -Id $DevWSObj[$DevWSObj.Length-1].Id.ToString() -AccessRight Admin -UserPrincipalName $SvcUser


Write-Host -ForegroundColor Green "Script Completed"

#Cleanup
#Invoke-PowerBIRestMethod -Url "groups/$($DevWSObj.Id.Guid)" -Method Delete 
#Invoke-PowerBIRestMethod -Url "groups/$($BuildWSObj.Id.Guid)" -Method Delete