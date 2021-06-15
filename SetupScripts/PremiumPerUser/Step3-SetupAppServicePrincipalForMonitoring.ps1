<#
    Author: John Kerski

    Dependencies: Azure CLI user has User Management/Global Admin rights.
#>

#Login
az login

#Sets to default subscription, so reset if needed

#Set Variabless
$AppPrincipalName = "DataOpsApp"

#Creates App
$AppClientId = az ad app create --display-name $AppPrincipalName --query "appId" | ConvertFrom-Json

if(!$AppClientId) {
    Write-Error "Unable to register an app."
    return
}
#Create service principal for the app just created
#This makes sure it is in active directory
$Output = az ad sp create --id $AppClientId

if(!$Output) {
    Write-Error "Unable to register an app as service principal."
    return
}

#Add Power BI permissions Dataset.Read.All, Report.Read.All, Workspace.Read.All
$PermOutput1 = az ad app permission add --id $AppClientId --api 00000009-0000-0000-c000-000000000000 --api-permissions 7f33e027-4039-419b-938e-2f8ca153e68e=Scope
$PermOutput2 = az ad app permission add --id $AppClientId --api 00000009-0000-0000-c000-000000000000 --api-permissions 4ae1bf56-f562-4747-b7bc-2fa0874ed46f=Scope
$PermOutput3 = az ad app permission add --id $AppClientId --api 00000009-0000-0000-c000-000000000000 --api-permissions b2f1b2fa-f35c-407c-979c-a858a808ba85=Scope
$GrantOutput = az ad app permission admin-consent --id $AppClientId

if(!PermOutput1 -Or !PermOutput2 -Or !PermOutput3 -Or !GrantOutput)
{
    Write-Error "Unable to grant Power BI permissions"
    return
}

#Finally create password for a year
$Password = az ad app credential reset --id $AppClientId --years 1 --query "password"

Write-Host -ForegroundColor Green "Please save ClientID: $($AppClientId) and Password: $($Password) to PBI Monitoring PPU."


