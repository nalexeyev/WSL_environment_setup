# If edit this file be careful with line endings. Must be Unix-style!
Write-Output 'Fix WSL network to use with VPN'
Write-Host 'BE AWARE!!! This script will overwrite /etc/wsl.conf and /etc/resolv.conf' -ForegroundColor Red -BackgroundColor Yellow
Read-Host -Prompt 'Press (Ctrl+C) to abort or ENTER to continue'
wsl sh -c "echo '[network]\ngenerateResolvConf = false' | sudo tee /etc/wsl.conf"
wsl -t Ubuntu

$NAMESERVERS=Get-DnsClientServerAddress -AddressFamily ipv4 | Select-Object -ExpandProperty ServerAddresses | Sort-Object -Unique 
Write-Output "Nameservers: $NAMESERVERS"

wsl sh -c "rm ~/resolv.conf.tmp"
foreach ($NAMESERVER in $NAMESERVERS)
{
   wsl sh -c "echo 'nameserver '$NAMESERVER >> ~/resolv.conf.tmp"
}
#wsl sh -c "sudo mkdir -p /run/resolvconf"
#wsl sh -c "sudo cp ~/resolv.conf.tmp /run/resolvconf/resolv.conf"
wsl sh -c "sudo rm -f /etc/resolv.conf && sudo cp ~/resolv.conf.tmp /etc/resolv.conf"
wsl sh -c "cat /etc/resolv.conf"

Read-Host -Prompt 'Done. Press ENTER to continue'
