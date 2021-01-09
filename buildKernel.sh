#!/bin/bash
# see https://medium.com/@alexanderyegorov_67403/how-to-compile-kernel-module-for-centos8-78287e9d145a

function preRequisites(){
    echo "uses sudo:"
    sudo dnf -y groupinstall "Development Tools"
    sudo dnf -y install ncurses-devel
    sudo dnf -y install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel
}

preRequisites

RPMBUILD_HOME=$(pwd)/rpmbuild

if [ ! -d ${RPMBUILD_HOME} ]; then
    #mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
    mkdir -p ${RPMBUILD_HOME}/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
fi

CENTOS_KERNEL=$(uname -r)
CENTOS_RPM=kernel-${CENTOS_KERNEL/x86_64/src.rpm}; # 4.18.0-240.1.1.el8_3.x86_64 --> 4.18.0-240.1.1.el8_3.rpm
if [ ! -f  ${CENTOS_RPM} ]; then
    # wget https://vault.centos.org/8.3.2011/BaseOS/Source/SPackages/kernel-4.18.0-240.1.1.el8_3.src.rpm
    wget https://vault.centos.org/$(cat /etc/centos-release | awk '{printf "%s", $4}')/BaseOS/Source/SPackages/${CENTOS_RPM}
fi


if [ ! -f ${CENTOS_RPM}/SPECS/kernel.spec ]; then
    if [ ! -f ~/.rpmmacros ]; then
        echo "%_topdir $RPMBUILD_HOME" > ~/.rpmmacros # the following rpm -- install will be redirected
    fi
    rpm --install ${CENTOS_RPM} # uses %_topdir from ~/.rpmmacros
    #rm ~/.rpmmacros
fi

function dnfInstall(){ #https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/31/Everything/x86_64/os/Packages/l/libdwarves1-1.15-3.fc31.x86_64.rpm
    local RPM_FILE=$(basename $1)
    wget $1 
    sudo dnf -y install ${RPM_FILE}
    rm ${RPM_FILE}
}
# more software needs to be installed
function preRequisites2(){
    #rpmbuild -bp --target=$(uname -m) kernel.spec
    #Building target platforms: x86_64
    #Building for target x86_64
    #error: Failed build dependencies:
    #	audit-libs-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	dwarves is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	elfutils-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	kabi-dw is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	libbabeltrace-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	libbpf-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	libcap-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	libcap-ng-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	llvm-toolset is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	newt-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	numactl-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	pciutils-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	python3-devel is needed by kernel-4.18.0-240.1.1.el8.x86_64
    #	xmlto is needed by kernel-4.18.0-240.1.1.el8.x86_64
    cd $RPMBUILD_HOME/SPECS # contains kernel.spec
    ERR_LIST=()
    PKG_LIST=`rpmbuild -bp --target=$(uname -m) kernel.spec 2>&1 | grep "is needed by" | awk '{print $1}' | tr '\n' ' '`
    for pkg in $PKG_LIST ; do
        echo "----------------sudo dnf -y install $pkg----------------"
        sudo dnf -y install $pkg
        if [ "$?" != "0" ]; then
            ERR_LIST=(${ERR_LIST[*]} $pkg)
        fi
    done
    if [ "${#ERR_LIST[*]}" != "0" ]; then
        echo " +---------------- not installed packages by dnf!-----------------------"
        echo " | ${ERR_LIST[*]}"
        echo " +----------------------------------------------------------------------"
        for missingLib in ${ERR_LIST[*]}; do
            if [ "$missingLib" == "dwarves" ]; then
                dnfInstall https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/31/Everything/x86_64/os/Packages/l/libdwarves1-1.15-3.fc31.x86_64.rpm
                dnfInstall https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/31/Everything/x86_64/os/Packages/d/dwarves-1.15-3.fc31.x86_64.rpm
            fi
            if [ "$missingLib" == "libbabeltrace-devel" ]; then
                dnfInstall https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/31/Everything/x86_64/os/Packages/l/libbabeltrace-1.5.7-2.fc31.x86_64.rpm
                dnfInstall https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/31/Everything/x86_64/os/Packages/l/libbabeltrace-devel-1.5.7-2.fc31.x86_64.rpm
            fi
            if [ "$missingLib" == "libbpf-devel" ]; then
                dnfInstall https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/31/Everything/x86_64/os/Packages/l/libbpf-0.0.3-1.fc31.x86_64.rpm
                dnfInstall https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/31/Everything/x86_64/os/Packages/l/libbpf-devel-0.0.3-1.fc31.x86_64.rpm
            fi
        done
    fi
}

preRequisites2

cd $RPMBUILD_HOME/SPECS # contains kernel.spec
rpmbuild -bp --target=$(uname -m) kernel.spec # build through %prep (unpack sources and apply patches) from <specfile>
if [ "$?" != "0" ]; then
    exit 1
fi

cd $RPMBUILD_HOME/BUILD/kernel-*/linux-*/
make oldconfig # using defaults found in /boot/config-4.18.0-240.1.1.el8_3.x86_64, configuration written to .config
make menuconfig #interactive
make prepare
make modules_prepare
make modules     # generates Module.symvers, otherwise: WARNING: Symbol version dump ./Module.symvers is missing; modules will have no dependencies and modversions.
echo "------------------------------------------------"
echo "now call buildMyDriver.sh"
echo "------------------------------------------------"
