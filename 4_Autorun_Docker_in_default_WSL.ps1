# If edit this file be careful with line endings. Must be Unix-style!

Write-Output 'Set autorun for Docker in WSL (native, not a Docker Desktop)'

$txt = '

#Start Docker daemon automatically when logging in if not running.

RUNNING=$(ps aux | grep dockerd | grep -v grep)
if [ -z "$RUNNING" ]; then
#    sudo dockerd > /dev/null 2>&1 &
    sudo dockerd -H tcp://0.0.0.0 > /dev/null 2>&1 &
    disown
fi

if [ ! -v DOCKER_HOST ]; then
    export DOCKER_HOST=tcp://127.0.0.1
fi
'
$bytes = [System.Text.Encoding]::ASCII.GetBytes($txt)
$output =[Convert]::ToBase64String($bytes)
wsl sh -c "echo $output | base64 -d >>  ~/.bashrc"

$txt = '

echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/dockerd"
'
$bytes = [System.Text.Encoding]::ASCII.GetBytes($txt)
$output =[Convert]::ToBase64String($bytes)

wsl sh -c "echo $output | base64 -d | sh | sudo tee -a /etc/sudoers"
