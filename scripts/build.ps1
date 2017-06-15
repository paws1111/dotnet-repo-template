
Param(
    [string]$Configuration="Debug",
    [string]$Restore="true",
    [string]$Version="<default>",
    [string]$BuildVersion=[System.DateTime]::Now.ToString('eyyMMdd-1')
)

Write-Host "Configuration=$Configuration."
Write-Host "Restore=$Restore."
Write-Host "Version=$Version."
Write-Host "BuildVersion=$BuildVersion."

if (!(Test-Path "dotnet\dotnet.exe")) {
    Write-Host "dotnet.exe not installed, downloading and installing."
    if ($Version -eq "<default>") {
        $Version = (Get-Content "$PSScriptRoot\..\DotnetCLIVersion.txt" -Raw).Trim()
    }
    Invoke-Expression -Command "$PSScriptRoot\install-dotnet.ps1 -Channel master -Version $Version -InstallDir $PSScriptRoot\..\dotnet"
    if ($lastexitcode -ne $null -and $lastexitcode -ne 0) {
        Write-Error "Failed to install latest dotnet.exe, exit code [$lastexitcode], aborting build."
        exit -1
    }
    Invoke-Expression -Command "$PSScriptRoot\install-dotnet.ps1 -Version 1.0.0 -InstallDir $PSScriptRoot\..\dotnet"
    if ($lastexitcode -ne $null -and $lastexitcode -ne 0) {
        Write-Error "Failed to install framework version 1.0.0, exit code [$lastexitcode], aborting build."
        exit -1
    }
}

$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE = 1