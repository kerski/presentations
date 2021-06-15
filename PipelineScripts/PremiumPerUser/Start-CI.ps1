<#
    Author: John Kerski
    Description: This script runs the proof-of-concept Continuous Integration of Power BI files into a Development workspace.

    Dependencies: Premium Per User license purchased and assigned to UserName and UserName has admin right to workspace.
#>
#Setup TLS 12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Get Working Directory
$WorkingDir = (& pwd) -replace "\\", '/'
Import-Module $WorkingDir/PipelineScripts/PremiumPerUser/Publish-PBIFIleWithPPU.psm1 -Force
Import-Module $WorkingDir/PipelineScripts/PremiumPerUser/Refresh-DatasetSyncWithPPU.psm1 -Force
Import-Module $WorkingDir/PipelineScripts/PremiumPerUser/Send-XMLAWithPPU.psm1 -Force
#Set Default Environment Variables 
$Opts = @{
    TenantId = "${env:TENANT_ID}";
    PbiApiUrl = "${env:PBI_API_URL}"
    BuildGroupId = "${env:PBI_BUILD_GROUP_ID}"
    DevGroupId = "${env:PBI_DEV_GROUP_ID}"
    UserName = "${env:PPU_USERNAME}";
    Password = "${env:PPU_PASSWORD}";
    #Get new pbix changes
    PbixChanges = git diff --name-only --relative --diff-filter AMR HEAD^ HEAD '**/*.pbix';
    PbixTracking = @();
    BuildVersion = "${env:BUILD_SOURCEVERSION}";
}
#Check for missing variables required for pipeline to work
if(-not $Opts.TenantId){
    throw "Missing or Blank Tenant ID"
}
if(-not $Opts.PbiApiUrl){
    throw "Missing or Blank Power BI Api URL"
}

if(-not $Opts.BuildGroupId){
    throw "Missing or Blank Build Group Id"
}

if(-not $Opts.DevGroupId){
    throw "Missing or Blank Dev Group Id"
}

if(-not $Opts.UserName){
    throw "Missing or Blank UserName"
}

if(-not $Opts.Password){
    throw "Missing or Blank Password"
}

#Iterate of Power BI Changes and get the test files
if($Opts.PbixChanges)
{	
	foreach ($File in $Opts.PbixChanges) {
        #If file exists and not deleted
        if($File)
        {
            #Get parent folder of this file
            $ParentFolder = Split-Path -Path $File
            #Add testing to object array
            $Temp = @([pscustomobject]@{PBIPath=$File;TestFolderPath=$ParentFolder;BuildInfo=$null;RefreshResult=$null})
            $Opts.PbixTracking += $Temp
        }#end if
	}#end for-each
}
else
{
	Write-Warning "Found no PBI files that have changed."
}#end if

#Install Powershell Module if Needed
if (Get-Module -ListAvailable -Name "MicrosoftPowerBIMgmt") {
    Write-Host "MicrosoftPowerBIMgmt already installed"
} else {
    Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser -AllowClobber -Force
}


#Iterate through Test Cases and Promote to Build Environment
$Iter = 0
foreach ($PBIPromote in $Opts.PbixTracking){
    Write-Host "File to Promote to Build Workspace: $($PBIPromote.PBIPath)"

    #Publish PBI file
    $Temp = Publish-PBIFIleWithPPU -WorkspaceId $Opts.BuildGroupId `
                     -LocalDatasetPath $PBIPromote.PBIPath `
                     -UserName $Opts.UserName `
                     -Password $Opts.Password `
                     -TenantId $Opts.TenantId `
                     -APIUrl $Opts.PbiApiUrl
    
    $Opts.PbixTracking[$Iter].BuildInfo = $Temp

    $Opts.PbixTracking[$Iter].BuildInfo
    $Iter = $Iter + 1
}#end foreach

#Now Test Refreshes
$Iter = 0
foreach($PBIPromote in $Opts.PbixTracking){
    Write-Host "Checking if file needs refreshing: $($PBIPromote.PBIPath)"

    #Check BuildInfo is not null.  If so then we can check if we can refresh dataset.
    if($PBIPromote.BuildInfo)
    {
        #If DatasetId property is null then this is a PowerBI report with a dataset needing a refresh
        if(!$PBIPromote.BuildInfo.DatasetId){ 
        $Temp = Refresh-DatasetSyncWithPPU -WorkspaceId $Opts.BuildGroupId `
                     -DatasetId $PBIPromote.BuildInfo.Id `
                     -UserName $Opts.UserName `
                     -Password $Opts.Password `
                     -TenantId $Opts.TenantId `
                     -APIUrl $Opts.PbiApiUrl
        
        Write-Host "Refresh Result"
        Write-Host $Temp


        #Update Refresh Result
        $Opts.PbixTracking[$Iter].RefreshResult = $Temp

        $Opts.PbixTracking[$Iter].RefreshResult
        
        Write-Host "Successfully refreshed: $($PBIPromote.PBIPath)"
        }#end if Power BI Report can be refreshed
    }#end if BUild Info Exists

    $Iter = $Iter + 1
}#end foreach


#Run Tests regardless of changes

#Find all files in working directory
$PBIsToTest = Get-ChildItem -Path "./pbi" -Recurse | Where-Object {$_ -like "*.pbix"}

#Set Client Secret as Secure String
$Secret = $Opts.Password | ConvertTo-SecureString -AsPlainText -Force
$Credentials = [System.Management.Automation.PSCredential]::new($Opts.UserName,$Secret)
#Connect to Power BI
Connect-PowerBIServiceAccount -Credential $Credentials

#Get Workspace Information to make sure we get the right Workspacename for XMLA
$BuildWS = Get-PowerBIWorkspace -Id $Opts.BuildGroupId 

#Setup Failed Test Counts and Results Array
$FailureCount = 0
$TestResults = @()

$Iter = 0
foreach($PBITest in $PBIsToTest){
    #Get parent folder of this file
    $ParentFolder = Split-Path -Path $PBITest.FullName
    #Get dax files in this folder
    $DaxFilesInFolder = Get-ChildItem -Path $ParentFolder | Where-Object {$_ -like "*.*dax"}    

    Write-Host "Attempting to run tests for: $($PBITest)"

    #Get the Report Information
    $TempRpt = Get-PowerBIReport -WorkspaceId $Opts.BuildGroupId -Name $PBITest.BaseName

    foreach($Test in $DaxFilesInFolder)
    {
        Write-Host "Running Tests found in $($Test.FullName)"

        $QueryResults = Send-XMLAWithPPU -WorkspaceName $BuildWS.Name `
                        -DatasetName $TempRpt.Name `
                        -UserName $Opts.UserName `
                        -Password $Opts.Password `
                        -TenantId $Opts.TenantId `
                        -APIUrl $Opts.PbiApiUrl `
                        -InputFile $Test.FullName     
                        
        #Get Node List
        [System.Xml.XmlNodeList]$Rows = $QueryResults.GetElementsByTagName("row")

        Write-Host "Row Count: $($Rows.Count)"

        #Check if Row Count is 0, no test results.
        if($Rows.Count -eq 0){
            $FailureCount += 1
            Write-Host -WarningAction Continue "Query in test file $($Test.FullName) returned no results."
        }#end check of results

        #Iterate through each row of the query results and check test results
        foreach($Row in $Rows)
        {
            #Expects Columns TestName, Expected, Actual Columns
            if($Row.ChildNodes.Count -ne 3)
            {
                $FailureCount +=1
                Write-Host -ErrorAction Continue -ForegroundColor Red "Query in test file $($Test.FullName) returned no results that did not have 3 columns (TestName, Expected, and Actual)."
            }
            else
            {
                #Extract Values
                $TestName = $row.ChildNodes[0].InnerText
                $ExpectedVal = $row.ChildNodes[1].InnerText
                $ActualVal = $row.ChildNodes[2].InnerText
                #Compute whether the test passed
                $Passed = ($ExpectedVal -eq $ActualVal) -and ($ExpectedVal -and $ActualVal)

                if(-not $Passed)
                {
                    $FailureCount +=1
                    Write-Host -ErrorAction Continue -ForegroundColor Red "FAILED!: Test $($TestName). Expected: $($ExpectedVal) != $($ActualVal)"
                }
                else
                {
                    Write-Host "Test $($TestName) passed. Expected: $($ExpectedVal) == $($ActualVal)"
                }

            }
        }#end foreach row
    }#end iterating over test files
    $Iter = $Iter + 1
}#end foreach PBI files


#If FailureCount is greater than 1
if($FailureCount -gt 0)
{
    Write-Host -ErrorAction Stop "$($FailureCount) failed test(s). Please resolve"
    Throw "$($FailureCount) failed test(s). Please resolve"
}
else #Promote to Development
{
    $Iter = 0
    foreach($PBIToDev in $PBIsToTest){
        #Get parent folder of this file
        $ParentFolder = Split-Path -Path $PBIToDev.FullName

        Write-Host "File to Promote to Development Workspace: $($PBIToDev.FullName)"

        #Publish PBI file
        $Temp = Publish-PBIFIleWithPPU -WorkspaceId $Opts.DevGroupId `
                         -LocalDatasetPath $PBIToDev.FullName `
                         -UserName $Opts.UserName `
                         -Password $Opts.Password `
                         -TenantId $Opts.TenantId `
                         -APIUrl $Opts.PbiApiUrl
        $Iter = $Iter + 1
    }#end foreach
}#end promot to development

return