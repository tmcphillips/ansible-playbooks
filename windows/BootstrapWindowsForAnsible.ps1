
#################################################################################################################################################################################
# How to run this script on a new installation of Windows:
#
# 1. Start a PowerShell instance running as Administrator.
#
# 2. Change directory to a temporary location such as C:\Temp.
#
#    cd C:\Temp
#
# 3. Download the script directly from GitHub:
#
#    Invoke-WebRequest https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/windows/BootstrapWindowsForAnsible.ps1 -OutFile BootstrapWindowsForAnsible.ps1
#
# 4. Execute the script.
#
#    PowerShell.exe -ExecutionPolicy RemoteSigned -File BootstrapWindowsForAnsible.ps1
#
# 5. When prompted enter your Windows user name and password.
#
# 6. When prompted optionally enter the directory containing SSH config and key files to be copied to your .ssh directory.
#
#################################################################################################################################################################################

function Out-Log {

    [cmdletbinding()]
    Param(
        [string]$message
    )
    Write-Host "BOOTSTRAP --> $message"
}

Out-Log "Enable execution of locally authored and signed remote PowerShell scripts..."
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
Out-Log "Display PowerShell execution policy..."
get-executionpolicy -List

Out-Log "Download and execute script for enabling remote system management by Ansible using WinRM...";
$WinRMEnableScript = "ConfigureRemotingForAnsible.ps1"
Invoke-WebRequest https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/$WinRMEnableScript  -Outfile $WinRMEnableScript
PowerShell.exe -File $WinRMEnableScript

Out-Log "Enable Windows Subsystem for Linux..."
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

if ($null -eq (Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
    Out-Log "Install Chocolatey..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Out-Log "Chocolatey already installed..."
}

if ($null -eq (Get-Command "git.exe" -ErrorAction SilentlyContinue)) {
    Out-Log "Install Git..."
    choco upgrade git
} else {
    Out-Log "Git already installed...";
}

Out-Log "Get the user's credentials"
$UserCredential = Get-Credential -Message "Enter name and password for your Windows account"

$SshKeySourceDir = Read-Host "Enter directory containing files to copy to .ssh directory"

Out-Log "Run the user account bootstrap script as the user..."
$Job = Start-Job -Credential $UserCredential {

    Write-Host "BOOTSTRAP --> Work in user's home directory...";
    Set-Location $Env:HOMEPATH

    $UserSshDir = "$Env:HOMEPATH\.ssh"
    if (-Not (Test-Path -Path $UserSshDir)) {
        Write-Host "BOOTSTRAP --> Create the user's .ssh directory..."
        New-Item -ItemType directory -Path $UserSshDir
    }

    if ($using:SshKeySourceDir) {
        Write-Host "BOOTSTRAP --> Copy keys to the user's .ssh directory..."
        Copy-Item "$using:SshKeySourceDir\*" -Destination $UserSshDir
    }

    $GitReposDir = "$Env:HOMEPATH\GitRepos"
    if (-Not (Test-Path -Path $GitReposDir)) {
        Write-Host "BOOTSTRAP --> Create the GitRepos directory..."
        New-Item -ItemType directory -Path $GitReposDir
    }
}

Wait-Job $Job
$JobResult = Receive-Job -Job $Job
$JobResult
