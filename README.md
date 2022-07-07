# WSL2_workspace_setup
Scripts for automated setup of WSL2 Ubuntu 20.04 and development workspace. Launch one by one in filename order or only selected ones.

If you plan to edit these files the text editor which supports Unix line endings is required.
VS Code is recommended.

## 1_Install_WSL.ps1
creates folders **WSL** and **workspace** in the root of chosen Windows logical disk, downloads from official site and deploys Ubuntu 20.04 distro to WSL folder with minimal Windows host intervention.

> :warning: Save your work before launching this script as it may reboot your host if Windows update will require it.

> **_NOTE:_** The workspace can be accessed as **~/workspace** in WSL or **:\workspace** in Windows host. If you want to unregister and uninstall WSL in the future, this will not affect your workspace. The whole WSL file system is available by \\\WSL$ from Windows Explorer
Use the created :\WSL\Backup folder on windows host to archive :\WSL\Ubuntu_2004\ext4.vhdx file. This will backup all other WSL staff except workspace

It is recommended to use Windows Terminal or MobaXTerm to access WSL CLI. Also it can be accessed as wsl.exe in Windows cmd.
> :warning: **Turn off VPN connection** for 1_Install_WSL.ps1 and **turn on** for other scripts!



## 2_Fix_Network_for_VPN_in_default_WSL.ps1
fixes issue when Internet is not accessible from WLS. It's recommended to connect VPN before this script launch.

## 3_Install_Docker_in_default_WSL.ps1
installs Docker and Docker-Compose to WSL in a Linux native way. To make dockerd auto-launched use 4_Autorun_Docker_in_default_WSL.ps1
> :warning: Avoid Docker Desktop installation or at least do ot use WSL2 integration plugin if you plan to run Windows containers. Otherwise the normal operation is not guaranteed. The provided here type of docker installation is fully functional and does not require Docker Desktop.

## 4_Autorun_Docker_in_default_WSL.ps1
makes dockerd auto-launched in WSL.

Comment out lines with
```
    export DOCKER_HOST
    sudo dockerd -H tcp://0.0.0.0 > /dev/null 2>&1 &
```
and uncomment
```
    sudo dockerd > /dev/null 2>&1 &
```
if you do not plan connect docker from Windows host

## 5_Launch_Docker_manually_in_default_WSL.ps1
launch dockerd manually (e.g. if it's crashed)

## 6_Set_static_ip_for_default_WSL.ps1
adds network alias to Windows host network interface and to WSL. After this, WSL can be reached from Windows host by the same IP
```
192.168.37.2
```
> :warning: Run this script after every reboot of the Windows host, and only if WSL is already running (otherwise Windows host network interface may be absent).

## 7_Put_record_for_static_ip_of_default_WSL_to_hosts_file.ps1
puts the record for the mentioned IP address (192.168.37.2) to the Windows hosts file

## 8_Shutdown_default_WSL.bat
shuts down **ALL** WSL instances

