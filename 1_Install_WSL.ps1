#Elevation
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#Large header is to face the powershell issue when subprocesses output overlaps console
Write-Output '****************************************************************************'
Write-Output '*                                                                          *'
Write-Output '* This script automates the environment initial setup.                     *'
Write-Output '* The setup includes:                                                      *'
Write-Output '* - Windows Update                                                         *'
Write-Output '* - Folder structure creation                                              *'
Write-Output '* - WSL (Windows Subsystem for Linux), Ubuntu 20.04 Distro deployment      *'
Write-Output '*                                                                          *'
Write-Output '****************************************************************************'

#Update Windows
Write-Host 'Windows Update in progress. Run this script again if the computer restarts. Reboot the computer manually if progess stopped for a long time (20+)' -Foreground Yellow
Import-Module PSWindowsUpdate
Install-WindowsUpdate -AcceptAll -AutoReboot

$DRIVE_LETTER = (Read-Host -Prompt 'Please enter the drive letter to install WSL and create folder structure').Trim().ToLower().Substring(0,1)

Write-Output "Creating folder structure in drive "$DRIVE_LETTER": ("$DRIVE_LETTER":\WSL, "$DRIVE_LETTER":\workspace)"
new-item -Path $DRIVE_LETTER":\" -Name 'workspace' -itemtype directory -Force | Out-Null
new-item -Path $DRIVE_LETTER":\WSL\" -Name 'Install' -itemtype directory -Force | Out-Null
new-item -Path $DRIVE_LETTER":\WSL\" -Name 'Backup' -itemtype directory -Force | Out-Null
new-item -Path $DRIVE_LETTER":\WSL\" -Name 'Ubuntu_2004' -itemtype directory -Force | Out-Null

If (-not (Test-Path -Path $DRIVE_LETTER":\WSL\Ubuntu_2004\ubuntu.exe")) {
    Write-Output 'Downloading Ubuntu 20.04 WSL distro'
    Set-Location $DRIVE_LETTER":\WSL\Install"
    Start-BitsTransfer -Source https://aka.ms/wslubuntu2004 -Destination WSLUbuntu2004.AppxBundle.zip -Priority high
    #Get-BitsTransfer | Complete-BitsTransfer
    Expand-Archive -LiteralPath .\WSLUbuntu2004.AppxBundle.zip -DestinationPath .\ -Force
    Get-ChildItem -Recurse -Path .\ | Where-Object {$PSItem.Name -notmatch '_x64.appx'} | Remove-Item -Recurse -Force
    $INSTALL_NAME=Get-ChildItem -Recurse -Path .\ | Where-Object {$PSItem.Name.EndsWith('_x64.appx')}
    Rename-Item $INSTALL_NAME -NewName $INSTALL_NAME'.zip'
    $INSTALL_NAME="$INSTALL_NAME"+'.zip'
    Expand-Archive -LiteralPath .\$INSTALL_NAME -DestinationPath $DRIVE_LETTER":\WSL\Ubuntu_2004" -Force
}

Write-Output 'Installing Windows features and Ubuntu WSL. Run this script again if the computer restarts'
if ((Get-WindowsOptionalFeature -FeatureName 'Microsoft-Windows-Subsystem-Linux' -Online).State -ne "Enabled") {
    Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -All -NoRestart
}
if ((Get-WindowsOptionalFeature -FeatureName 'VirtualMachinePlatform' -Online).State -ne "Enabled") {
    Enable-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform' -All
}
Write-Output 'Now wait until WSL distro is installed, then setup username and password'
wsl --set-default-version 2
Start-Process $DRIVE_LETTER":\WSL\Ubuntu_2004\ubuntu.exe"
Start-Sleep -Seconds 10
wsl -l -v
Write-Output 'If WSL distro is not of VERSION 2 then interrupt this script (Ctrl+C) and fix it'
Write-Output 'Maybe your hardware does not support virtualization'
Write-Host 'If you entered username and password in WSL and version is 2 (see table above) then' -Foreground Yellow
Read-Host -Prompt 'press (Ctrl+C) to abort or ENTER to continue'

Write-Output ' '
Write-Host "Setup workspace directory. You can access it as ~/workspace in WSL or "$DRIVE_LETTER":\workspace in Windows host" -ForegroundColor Yellow
Write-Host 'If you want to unregister and uninstall WSL in the future, this will not affect your workspace.' -ForegroundColor Yellow
Write-Host 'Whole WSL file system is available by \\WSL$ from Windows Explorer' -ForegroundColor Yellow
wsl -d Ubuntu sh -c "ln -s /mnt/$DRIVE_LETTER/workspace ~/workspace"

Read-Host -Prompt 'Done. Press ENTER to continue'
