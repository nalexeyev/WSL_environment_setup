#Elevation
#Alternatively use #Requires -RunAsAdministrator

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

$network = "192.168.37"

#This IP is to assign to Windows host
$ip = $network+".1"

#This IP is to assign to WSL
$wslip = $network+".2"

$netmask = "24"
$broadcastip = $network+".255"

wsl sh -c "sudo ip addr add $wslip/$netmask broadcast $broadcastip dev eth0 label eth0:WSL"
#Please check the name for WSL adapter in Windows Network&Internet settings GUI. Should be vEthernet (WSL)
netsh interface ip add address name="vEthernet (WSL)" $ip 255.255.255.0

Read-Host -Prompt 'Done. Press ENTER to continue'
