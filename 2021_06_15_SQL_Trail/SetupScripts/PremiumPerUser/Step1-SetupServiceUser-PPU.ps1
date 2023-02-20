<#
    Author: John Kerski
    Description: This script creates service user and assigns Premium Per User License.

    Dependencies: Must have user admin role in order to create user and Premium Per User license purchased.
#>
#Install MSOnline Powershell Module if Needed
if (Get-Module -ListAvailable -Name "MsOnline") {
    Write-Host "MsOnline installed moving forward"
} else {
    #Install MsOnline Module
    Install-Module -Name MsOnline
}

#Set Variables
$SvcUserDispName = "DataOpsSvc"
$SvcUser = "{USERNAME}"
$SvcUserPwd = "{PASSWORD}"
$PPULicense = "{TENANT}:PBI_PREMIUM_PER_USER"
$UsageLoc = "US"
#Login
Connect-MsolService

#Create User and Assign License
New-MsolUser -UserPrincipalName $SvcUser -DisplayName $SvcUserDispName -UsageLocation $UsageLoc -LicenseAssignment $PPULicense -ForceChangePassword $false -PasswordNeverExpires $true -Password $SvcUserPwd

Write-Host "${SvcUserDispName} created and assigned Premium Per User" -ForegroundColor Green


#Cleanup
#Remove-MsolUser -UserPrincipalName $SvcUser -Force
#Remove-MsolUser -UserPrincipalName $SvcUser -RemoveFromRecycleBin -Force