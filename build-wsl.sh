#!/usr/bin/env bash
# Build environment is based on latest stable Fedora. This is here for transparency but you may use it if you wish to build your own kernel for WSL2
sudo zypper -n up
sudo bash -c "zypper in -y -t pattern devel_basis && zypper in -y bc openssl openssl-devel dwarves rpm-build libelf-devel aria2 jq"
mkdir -p kernel-wsl2
cd kernel-wsl2
curl -s https://api.github.com/repos/microsoft/WSL2-Linux-Kernel/releases/latest | jq -r '.name' | sed 's/$/.tar.gz/' | sed 's#^#https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/#' | aria2c -i -
tar -xf *.tar.gz
cd "$(find -type d -name "WSL2-Linux-Kernel-linux-msft-wsl-*")"
cp Microsoft/config-wsl .config
sed -i 's/# CONFIG_KVM_GUEST is not set/CONFIG_KVM_GUEST=y/g' .config
sed -i 's/# CONFIG_ARCH_CPUIDLE_HALTPOLL is not set/CONFIG_ARCH_CPUIDLE_HALTPOLL=y/g' .config
sed -i 's/# CONFIG_HYPERV_IOMMU is not set/CONFIG_HYPERV_IOMMU=y/g' .config
sed -i '/^# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set/a CONFIG_PARAVIRT_CLOCK=y' .config
sed -i '/^# CONFIG_CPU_IDLE_GOV_TEO is not set/a CONFIG_CPU_IDLE_GOV_HALTPOLL=y' .config
sed -i '/^CONFIG_CPU_IDLE_GOV_HALTPOLL=y/a CONFIG_HALTPOLL_CPUIDLE=y' .config
sed -i 's/CONFIG_HAVE_ARCH_KCSAN=y/CONFIG_HAVE_ARCH_KCSAN=n/g' .config
sed -i '/^CONFIG_HAVE_ARCH_KCSAN=n/a CONFIG_KCSAN=n' .config
#Setting core count to 7 as a 6 core CPU is more common
make -j 7
if [ test -f '/etc/wsl.conf' ]; then
    powershell.exe /C 'Copy-Item .\arch\x86\boot\bzImage $env:USERPROFILE'
    powershell.exe /C 'Write-Output [wsl2]`nkernel=$env:USERPROFILE\bzImage | % {$_.replace("\","\\")} | Out-File $env:USERPROFILE\.wslconfig -encoding ASCII'
    echo '[!!] Build done! The kernel has been moved for you and set up'
else
    echo -e "[!!] Build done! Please move the bzImage file from 'kernel-wsl2/arch/x86/boot' to your Windows PC or VM and add the kernel to your .wslconfig"
fi