#!/bin/bash
# see https://medium.com/@alexanderyegorov_67403/how-to-compile-kernel-module-for-centos8-78287e9d145a

set -eE
set -u  # turn on strict variable checking
# debugging
#set -x  # trace all function calls

function failure() { local lineno=$1;  local msg=$2
  echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR ;#  trap [-lp] [[arg] sigspec ...], sigspec: ERR,EXIT,RETURN,DEBUG


DNF=dnf
function yum_or_dnf(){
    which yum && DNF=yum
}
yum_or_dnf

function preRequisites(){
    echo "----------------------------------------------------------------------preRequisites"
    echo "uses sudo:"
    sudo $DNF -y groupinstall "Development Tools"
    sudo $DNF -y install ncurses-devel
    sudo $DNF -y install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel
}

preRequisites

RPMBUILD_HOME=$(pwd)/rpmbuild

if [ ! -d ${RPMBUILD_HOME} ]; then
    #mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
    mkdir -p ${RPMBUILD_HOME}/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
fi

CENTOS_KERNEL=$(uname -r); #3.10.0-1160.el7.x86_64
#CENTOS_RPM=kernel-${CENTOS_KERNEL/x86_64/src.rpm}; # 4.18.0-240.1.1.el8_3.x86_64 --> 4.18.0-240.1.1.el8_3.src.rpm

CENTOS_RPM=
function findLatestKernel(){
    if [[ "$1" == "https://"* ]]; then
      readarray -t lines < <(wget -qO- $1 | grep -e "^ *<tr")
    else
      readarray -t lines < $1
    fi
    declare -A dict
    for line in "${lines[@]}"; do
      # <a href="kernel-4.18.0-315.el8.src.rpm">kernel-4.18.0-315.el8.src.rpm</a></td><td class="indexcollastmod">2021-06-28 20:45  </td>
      if [[ "$line" =~ href=\"kernel-[^\>]+\>([^<]+)\<.+lastmod\"\>([^<]+)\< ]]; then
        echo "${BASH_REMATCH[2]} ${BASH_REMATCH[1]} "
        local kdate=${BASH_REMATCH[2]/ /_};   # "2021-10-20 16:52  " --> "2021-10-20_16:52  "
        kdate=$(echo "$kdate" | sed 's/ //g');# "2021-10-20_16:52  " --> "2021-10-20_16:52"
        dict[$kdate]="${BASH_REMATCH[1]}"
      fi
    done
    # sort 
    ARR=($(echo "${!dict[@]}" | tr ' ' '\n' | sort -r))
    CENTOS_RPM=${dict[${ARR[0]}]}
}

function downloadRpm(){
  # per 2023.04.06: https://vault.centos.org/
  #[DIR]	7.0.1406/	2015-04-07 14:36 	- os/Source/SPackages/kernel-3.10.0-123.el7.src.rpm
  #[DIR]	7.1.1503/	2015-11-13 13:01 	- os/Source/SPackages/kernel-3.10.0-229.el7.src.rpm	 
  #[DIR]	7.2.1511/	2016-05-18 16:48 	- ...	 
  #[DIR]	7.3.1611/	2017-02-20 22:21 	- 	 
  #[DIR]	7.4.1708/	2018-02-26 14:32 	- 	 
  #[DIR]	7.5.1804/	2018-05-09 20:39 	- 	 
  #[DIR]	7.6.1810/	2018-12-02 14:34 	- 	 
  #[DIR]	7.7.1908/	2019-09-15 01:00 	- 	 
  #[DIR]	7.8.2003/	2020-06-17 17:55 	- 	 
  #[DIR]	7.9.2009/	2021-01-18 14:14 	- os/Source/SPackages/kernel-3.10.0-1160.el7.src.rpm	 
  #
  #[DIR]	8.0.1905/	2020-09-09 07:43 	- BaseOS/Source/SPackages/kernel-4.18.0-80.el8.src.rpm, -80.1.2, -80.4.2, -80.7.1, -80.7.2, -80.11.1, -80.11.2
  #[DIR]	8.1.1911/	2020-10-21 07:53 	- BaseOS/Source/SPackages/kernel-4.18.0-147.el8.src.rpm, -147.0.3, -147.3.1, 07.5.1, -147.8.1

  #[DIR]	8.2.2004/	2021-01-15 09:07 	- ...
  #[DIR]	8.3.2011/	2021-04-27 16:00 	- 	 
  #[DIR]	8.4.2105/	2021-11-09 02:22 	- 	 
  #[DIR]	8.5.2111/	2021-12-22 00:53 	- BaseOS/Source/SPackages/kernel-4.18.0-348.el8.src.rpm, -348.2.1, -348.7.1
  #
  #[DIR]	8-stream/	2022-01-18 21:58 	- BaseOS/Source/SPackages/kernel-4.18.0-294.el8.src.rpm, ... 	kernel-4.18.0-448.el8.src.rpm
  
  echo "----------------------------------------------------------------------downloadRpm"
  # cat /etc/centos-release
  #   CentOS Stream release 8
  #   CentOS Linux release 8.5.2111
  CENTOS_RELEASE=$(cat /etc/centos-release); # "CentOS Linux release 7.9.2009 (core)", "CentOS Stream release 8"
  if [[ "$CENTOS_RELEASE" =~ CentOS[[:space:]](.+)[[:space:]]release[[:space:]]([0-9.]+) ]]; then
     RELEASE_STR=${BASH_REMATCH[1]}; # Stream | Linux
     RELEASE_NO=${BASH_REMATCH[2]};  # 8      | 8.5.2111
     if [ "$RELEASE_STR" == "Stream" ]; then
       RELEASE_NO=${RELEASE_NO}-stream; #8-stream for url
     fi
  else
     echo "/ext/centos-release not in form: CentOS Linux release 7.9.2009 (core), ..."
     exit 1
  fi
  BASE_OS=BaseOS
  set +e
  wget -q --spider https://vault.centos.org/$RELEASE_NO/BaseOS/Source/SPackages/
  if [ "$?" != "0" ]; then
     BASE_OS=os
     wget -q --spider https://vault.centos.org/$RELEASE_NO/os/Source/SPackages/
     if [ "$?" != "0" ]; then
       echo ""
       exit 1
     fi
  fi
  set -e
  
  findLatestKernel https://vault.centos.org/$RELEASE_NO/$BASE_OS/Source/SPackages/
  
  if [ ! -f  ${CENTOS_RPM} ]; then
      # wget https://vault.centos.org/8.3.2011/BaseOS/Source/SPackages/kernel-4.18.0-240.1.1.el8_3.src.rpm
      echo "-------------------------------------------------------------------------"
      echo "wget https://vault.centos.org/$RELEASE_NO/$BASE_OS/Source/SPackages/${CENTOS_RPM}"
      echo "-------------------------------------------------------------------------"
      wget -q https://vault.centos.org/$RELEASE_NO/$BASE_OS/Source/SPackages/${CENTOS_RPM}
  fi
}

echo "--------------------downloadRpm"
downloadRpm

function rpmInstall(){
  if [ ! -f ${RPMBUILD_HOME}/SPECS/kernel.spec ]; then
    if [ ! -f ~/.rpmmacros ]; then
        echo "%_topdir $RPMBUILD_HOME" > ~/.rpmmacros # the following rpm -- install will be redirected
    fi
    DO_DEL=0
    set +e # turn off
    cat /etc/passwd | grep mockbuild
    if [ "$?" != "0" ]; then
      sudo useradd -s /sbin/nologin mockbuild
      DO_DEL=1
    fi
    set -e
    rpm --install ${CENTOS_RPM} # uses %_topdir from ~/.rpmmacros
    if [ "$DO_DEL" == "1" ]; then
      sudo userdel mockbuild
    fi
    #rm ~/.rpmmacros
  fi
}

echo "--------------------rpmInstall"
rpmInstall

function dnfInstall(){ #https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/31/Everything/x86_64/os/Packages/l/libdwarves1-1.15-3.fc31.x86_64.rpm
    local RPM_FILE=$(basename $1)
    wget $1 
    sudo $DNF -y install ${RPM_FILE}
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
        set +e
        sudo $DNF -y install $pkg
        if [ "$?" != "0" ]; then
            ERR_LIST=(${ERR_LIST[*]} $pkg)
        fi
        set -e
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

echo "--------------------preRequisites2"
preRequisites2

cd $RPMBUILD_HOME/SPECS # contains kernel.spec
echo "--------------------rpmbuild -bp --target=$(uname -m) kernel.spec"
rpmbuild -bp --target=$(uname -m) kernel.spec # build through %prep (unpack sources and apply patches) from <specfile>
if [ "$?" != "0" ]; then
    echo "--------------------------------------------error in rpmbuild"
    exit 1
fi

#./rpmbuild/SOURCES/kernel-x86_64-debug.config:CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
#./rpmbuild/SOURCES/kernel-x86_64.config:CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
#./rpmbuild/BUILD/kernel-4.18.0-448.el8/linux-4.18.0-448.el8.x86_64/drivers/media/Kconfig:
  #
  # Ancillary drivers (tuners, i2c, spi, frontends)
  #
  #config MEDIA_SUBDRV_AUTOSELECT
  #      bool "Autoselect ancillary drivers (tuners, sensors, i2c, spi, frontends)"
  #      depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT || MEDIA_SDR_SUPPORT
# drivers/media/i2c/Kconfig:
#menu "I2C Encoders, decoders, sensors and other helper chips"
#        visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST


cd $RPMBUILD_HOME/BUILD/kernel-*/linux-*/
make oldconfig # using defaults found in /boot/config-4.18.0-240.1.1.el8_3.x86_64, configuration written to .config
if [ -f .config ]; then cp .config .config.bak; fi
make menuconfig #interactive
meld .config .config.bak
make prepare
make modules_prepare
make modules     # generates Module.symvers, otherwise: WARNING: Symbol version dump ./Module.symvers is missing; modules will have no dependencies and modversions.
find . -name Module.symvers
echo "------------------------------------------------"
echo "now call buildMyDriver.sh"
echo " i.e.: ./buildGO7007.sh"
echo "------------------------------------------------"
