#!/usr/bin/env bash
echo -e "[+] This will compile locally a release of the WSL2 kernel you provide from microsoft's github and enable KVM, HyperV and Paravirtualisation modules with the intent of running a nested hypervisor under WSL2. /n Binaries are in the Kernel folder for the latest 2 releases of each series. /n This script is provided for simplicity and transparency providing reproducable builds of the binaries included in this repo. There is no need to use this unless the provided binaries are too new or too old."
if [ -f /etc/redhat-release ] || [ -f /etc/fedora-release  ]; then
    sudo dnf upgrade -y --refresh
    sudo dnf install -y qt5-qtbase-devel libXi-devel gcc-c++ kernel-devel kernel-headers openssl bc openssl-devel elfutils-libelf-devel aria2 jq
elif [ -f /etc/debian_version ]; then
    sudo apt update
    sudo apt install -y build-essential flex bison dwarves libssl-dev libelf-dev jq aria2 bc
elif [ -f /etc/suse-release ]; then
    sudo zypper -n up
    sudo bash -c "zypper in -y -t pattern devel_basis && zypper in -y bc openssl openssl-devel dwarves rpm-build libelf-devel aria2 jq"
fi
if [ -f ./*linux-msft-wsl-*.tar.gz ]; then
    echo -e "[+] Kernel found, unpacking."
    mkdir -p kernel-wsl2
    mv *.tar.gz kernel-wsl2
    cd kernel-wsl2
    tar -xf *.tar.gz
    echo -e "[+] config found, starting build"
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
else
    echo -e " [!!]  Please place an archive (.tar.gz) of the kernel you are wanting to build in this folder and run again folder. Please do not rename the archive before moving it here."
    exit 0
fi
if [ -f "/etc/wsl.conf" ]; then
    powershell.exe /C 'Copy-Item .\arch\x86\boot\bzImage $env:USERPROFILE'
    powershell.exe /C 'Write-Output [wsl2]`nkernel=$env:USERPROFILE\bzImage | % {$_.replace("\","\\")} | Out-File $env:USERPROFILE\.wslconfig -encoding ASCII'
    echo '[!!] Build done! The kernel has been moved for you and set up'
else
    echo -e "[!!] Build done! Please move the bzImage file from 'kernel-wsl2/arch/x86/boot' to your Windows PC or VM and add the kernel to your .wslconfig"
fi