
# Download and run this script in a PowerShell instance running as Administrator:
#
#   Invoke-WebRequest https://raw.githubusercontent.com/tmcphillips/ansible-playbooks/master/windows/bootstrap.ps1 -OutFile bootstrap.ps1
#   PowerShell.exe -ExecutionPolicy RemoteSigned -File bootstrap.ps1

# permanently enable PowerShell script execution
Write-Output "BOOTSTRAP | Enable execution of locally authored and signed remote PowerShell scripts...";
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine # -Confirm

Write-Output "BOOTSTRAP | Display PowerShell execution policy...";
get-executionpolicy -List

# enable WSL subsystem

# ensure the .ssh directory exists

# copy ssh keys to .ssh directory

# ensure the GitRepos directory exists

# install git

# clone the ansible-playbooks repo

