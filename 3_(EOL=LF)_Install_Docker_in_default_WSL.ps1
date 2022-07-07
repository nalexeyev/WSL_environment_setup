# If edit this file be careful with line endings. Must be Unix-style!
Write-Output 'Setup Docker in WSL (native, no Docker Desktop)'

wsl sh -c "cat > ~/install_docker.sh<< EOF
#!/usr/bin/env bash
echo -e '\n- Removing old versions. It is OK if apt-get reports that none of these packages are installed\n'
echo 'docker docker-engine docker.io containerd runc' | xargs -n 1  sudo apt remove -y
curl -fsSL https://get.docker.com -o get-docker.sh
echo -e '\n- Installing the recent Docker version. Do not worry about Docker Desktop recommendation in WSL\n'
sudo sh ./get-docker.sh
sudo usermod -a -G docker `$USER
echo -e '\n- Installing the recent Docker-Compose switch to allow the docker-compose command\n'
curl -fsSL https://raw.githubusercontent.com/docker/compose-switch/master/install_on_linux.sh -o install_on_linux.sh
sudo sh ./install_on_linux.sh
sudo update-alternatives --install /usr/local/bin/docker-compose docker-compose /usr/local/bin/compose-switch 99
EOF"

wsl sh -c "chmod +x ~/install_docker.sh"
Write-Host 'Please, ignore the message ''WSL DETECTED: We recommend using Docker Desktop for Windows.'' in helper script' -ForegroundColor Yellow
wsl sh -c "sudo ~/install_docker.sh"

wsl sh -c "docker -v"
wsl sh -c "docker-compose -v"

Read-Host -Prompt 'Done. Press ENTER to continue'
