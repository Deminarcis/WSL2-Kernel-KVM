# WSL2-Kernel-KVM
Builds of the wsl2 kernel suited for running KVM under Windows

This Repo will contain builds for the latest stable for each series hosted in Microsoft's Repo
These are the same builds used in (Commandant)[gitub.com/deminarcis/commandant] and is to act as an archive.

Included are the build scripts and binaries. You dont have to build this yourself but you can

I recommend building in WSL2 using the OpenSUSE Tumbleweed contianer from MS Store, although there is a script for bulding on Fedora (tested on Fedora 38 and 39, should also work on RHEL and CentOS 9)

### Building
In your Opensuse container under WSL2 clone the repo and run `build-wsl.sh`
Alternately if building on Fedora use the included script
To clean things up just delete the `kernel-wsl2` folder once you have moved the bzImage file out