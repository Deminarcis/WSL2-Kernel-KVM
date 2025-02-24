#!/bin/sh
if [ -f "/etc/wsl.conf" ]; then
    powershell.exe /C 'Copy-Item .\bzImage $env:USERPROFILE'
    powershell.exe /C 'Write-Output [wsl2]`nkernel=$env:USERPROFILE\bzImage | % {$_.replace("\","\\")} | Out-File $env:USERPROFILE\.wslconfig -encoding ASCII'
    echo '[!!] The kernel has been moved for you and set up'
else
    echo -e "[!!] Please move the bzImage file to your Windows PC or VM and add the kernel to your .wslconfig"
fi