# buildCentosKernel
Script for building Centos kernel and modules/drivers.

Builds the actual Centos kernel (tested with 4.18.0-240.1.1.el8_3.x86_64)

buildKernel.sh downloads the actual kernel rpm file and compiles it in the rpmbuild directory.

It contains an interactive part "make menuconfig". With it system modules can be activated
After compiling the kernel and modules a script for building and installing a particular module can be called.
At the moment only a script for WIS-GO7007 module compiling is present: buildGO7007.sh

