#!/bin/sh
if [ -f "/etc/wsl.conf" ]; then
    powershell.exe /C 'Copy-Item .\arch\x86\boot\bzImage $env:USERPROFILE'
    powershell.exe /C 'Write-Output [wsl2]`nkernel=$env:USERPROFILE\bzImage | % {$_.replace("\","\\")} | Out-File $env:USERPROFILE\.wslconfig -encoding ASCII'
    echo '[!!] Build done! The kernel has been moved for you and set up'
else
    echo -e "[!!] Build done! Please move the bzImage file from 'kernel-wsl2/arch/x86/boot' to your Windows PC or VM and add the kernel to your .wslconfig"
fi