# WSL2-Kernel-KVM
Builds of the wsl2 kernel suited for running KVM under Windows

This Repo will contain builds for the latest stable for each series hosted in Microsoft's Repo
These are the same builds used in (Commandant)[gitub.com/deminarcis/commandant] and is to act as an archive.

Included are the build scripts and binaries. You dont have to build this yourself but you can if you want

#### Linux:
I have tested on Fedora 38 and 39, but dependencies are listed for Debian and OpenSUSE

### Building
In your container under WSL2 clone the repo and run `build-wsl.sh`
Alternately if building on a linux host, run the included script directly
To clean things up just delete the `kernel-wsl2` folder once you have moved the bzImage file out