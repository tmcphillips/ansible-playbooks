
#################################################################################################################################################################################
# How to run this script on a new installation of Windows:
#
# 1. Start a PowerShell instance running as Administrator.
#
# 2. Change directory to a temporary location such as C:\Temp
#
#       cd C:\Temp
#
# 3. Download the script directly from GitHub:
#
#       Invoke-WebRequest https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/windows/BootstrapWindowsForAnsible.ps1 -OutFile BootstrapWindowsForAnsible.ps1
#
# 4. Execute the script:
#
#       PowerShell.exe -ExecutionPolicy RemoteSigned -File BootstrapWindowsForAnsible.ps1
#
#################################################################################################################################################################################

Write-Host "BOOTSTRAP --> Enable execution of locally authored and signed remote PowerShell scripts...";
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine # -Confirm
Write-Host "BOOTSTRAP --> Display PowerShell execution policy...";
get-executionpolicy -List

Write-Host ""
Write-Host "BOOTSTRAP --> Download and execute script for enabling remote system management by Ansible using WinRM...";
Invoke-WebRequest https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -Outfile ConfigureRemotingForAnsible.ps1
PowerShell.exe -File ConfigureRemotingForAnsible.ps1

Write-Host "BOOTSTRAP --> Enable Windows Subsystem for Linux...";
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

if ($null -eq (Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "BOOTSTRAP --> Install Chocolatey...";
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host "BOOTSTRAP --> Chocolatey already installed...";
}

if ($null -eq (Get-Command "git.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "BOOTSTRAP --> Install Git...";
    choco upgrade git
} else {
    Write-Host "BOOTSTRAP --> Git already installed...";
}

Write-Host "BOOTSTRAP --> Get the user's credentials";
$UserCredential = Get-Credential -Message "Enter name and password for your Windows account"


$SshKeySourceDir = Read-Host "Enter directory containing files to copy to .ssh directory"

Write-Host "BOOTSTRAP --> Run the user account bootstrap script as the user...";
$Job = Start-Job -Credential $UserCredential {

    Write-Host "BOOTSTRAP --> Work in user's home directory...";
    Set-Location $Env:HOMEPATH

    $UserSshDir = "$Env:HOMEPATH\.ssh"

    if (-Not (Test-Path -Path $UserSshDir)) {
        Write-Host "BOOTSTRAP --> Create the user's .ssh directory...";
        New-Item -ItemType directory -Path $UserSshDir
    }

    if ($using:SshKeySourceDir) {
        Write-Host "BOOTSTRAP --> Copy keys to the user's .ssh directory...";
        Copy-Item "$using:SshKeySourceDir\*" -Destination $UserSshDir
    }

    if (-Not (Test-Path -Path .\GitRepos)) {
        Write-Host "BOOTSTRAP --> Create the GitRepos directory...";
        New-Item -ItemType directory -Path GitRepos
    }
}

Wait-Job $Job
$JobResult = Receive-Job -Job $Job
$JobResult
