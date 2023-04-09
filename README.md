# BuildKernelModules
The wiki (https://wiki.centos.org/action/login/HowTos/BuildingKernelModules) provides a comprehensive guide on building kernel modules, but for those who want to streamline the process, the buildKernelModules.sh bash script can be incredibly useful. This script automates all the necessary steps, from downloading the current kernel rpm file to compiling it in the local rpmbuild subdirectory.

One of the standout features of this script is its interactive component, "make menuconfig." This feature allows users to activate system modules with ease, making the process of customizing the kernel more efficient.

After the kernel and modules are compiled, the script also provides a way to build and install specific modules. Currently, the buildGO7007.sh script is the only one available for compiling the WIS-GO7007 module.

Overall, the buildKernelModules.sh script simplifies and streamlines the process of building kernel modules, making it a valuable tool for developers and users alike.
