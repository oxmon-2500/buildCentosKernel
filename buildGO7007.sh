#!/bin/bash
# make menuconfig #interactive find /GO7007
#  │ Symbol: VIDEO_GO7007 [=n]                                                                                                                                │  
#  │ Type  : tristate                                                                                                                                         │  
#  │ Prompt: WIS GO7007 MPEG encoder support                                                                                                                  │  
#  │   Location:                                                                                                                                              │  
#  │     -> Device Drivers                                                                                                                                    │  
#  │       -> Multimedia support (MEDIA_SUPPORT [=m])                                                                                                         │  
#  │ (1)     -> Media USB Adapters (MEDIA_USB_SUPPORT [=y])                                                                                                   │  
#  │   Defined at drivers/media/usb/go7007/Kconfig:1                                                                                                          │  
#  │   Depends on: MEDIA_SUPPORT [=m] && MEDIA_USB_SUPPORT [=y] && MEDIA_ANALOG_TV_SUPPORT [=y] && VIDEO_DEV [=m] && I2C [=y] && SND [=m] && USB [=y]         │  
#  │   Selects: VIDEOBUF2_VMALLOC [=m] && VIDEO_TUNER [=m] && CYPRESS_FIRMWARE [=m] && SND_PCM [=m] && VIDEO_SONY_BTF_MPX [=n] && VIDEO_SAA711X [=m] && VIDEO │  
#  │                                                                                                                                                          │  
#  │                                                                                                                                                          │  
#  │ Symbol: VIDEO_GO7007_LOADER [=n]                                                                                                                         │  
#  │ Type  : tristate                                                                                                                                         │  
#  │ Prompt: WIS GO7007 Loader support                                                                                                                        │  
#  │   Location:                                                                                                                                              │  
#  │     -> Device Drivers                                                                                                                                    │  
#  │       -> Multimedia support (MEDIA_SUPPORT [=m])                                                                                                         │  
#  │         -> Media USB Adapters (MEDIA_USB_SUPPORT [=y])                                                                                                   │  
#  │ (2)       -> WIS GO7007 MPEG encoder support (VIDEO_GO7007 [=n])                                                                                         │  
#  │   Defined at drivers/media/usb/go7007/Kconfig:33                                                                                                         │  
#  │   Depends on: USB [=y] && MEDIA_SUPPORT [=m] && MEDIA_USB_SUPPORT [=y] && MEDIA_ANALOG_TV_SUPPORT [=y] && VIDEO_GO7007 [=n]                              │  
#  │                                                                                                                                                          │  
#  │                                                                                                                                                          │  
#  │ Symbol: VIDEO_GO7007_USB [=n]                                                                                                                            │  
#  │ Type  : tristate                                                                                                                                         │  
#  │ Prompt: WIS GO7007 USB support                                                                                                                           │  
#  │   Location:                                                                                                                                              │  
#  │     -> Device Drivers                                                                                                                                    │  
#  │       -> Multimedia support (MEDIA_SUPPORT [=m])                                                                                                         │  
#  │         -> Media USB Adapters (MEDIA_USB_SUPPORT [=y])                                                                                                   │  
#  │ (3)       -> WIS GO7007 MPEG encoder support (VIDEO_GO7007 [=n])                                                                                         │  
#  │   Defined at drivers/media/usb/go7007/Kconfig:23                                                                                                         │  
#  │   Depends on: MEDIA_SUPPORT [=m] && MEDIA_USB_SUPPORT [=y] && MEDIA_ANALOG_TV_SUPPORT [=y] && VIDEO_GO7007 [=n] && USB [=y]                              │  
#  │                                                                                                                                                          │  
#  │                                                                                                                                                          │  
#  │ Symbol: VIDEO_GO7007_USB_S2250_BOARD [=n]                                                                                                                │  
#  │ Type  : tristate                                                                                                                                         │  
#  │ Prompt: Sensoray 2250/2251 support                                                                                                                       │  
#  │   Location:                                                                                                                                              │  
#  │     -> Device Drivers                                                                                                                                    │  
#  │       -> Multimedia support (MEDIA_SUPPORT [=m])                                                                                                         │  
#  │ (4)     -> Media USB Adapters (MEDIA_USB_SUPPORT [=y])                                                                                                   │  
#  │   Defined at drivers/media/usb/go7007/Kconfig:44                                                                                                         │  
#  │   Depends on: MEDIA_SUPPORT [=m] && MEDIA_USB_SUPPORT [=y] && MEDIA_ANALOG_TV_SUPPORT [=y] && VIDEO_GO7007_USB [=n] && USB [=y]                          │  
#  │                                                                                                                                                          │  
#  │                                                                                                                                                          │  
#  │ Symbol: VIDEO_GO7007_USB_S2250_BOARD [=n]                                                                                                                │  
#  │ Type  : tristate                                                                                                                                         │  
#  │ Prompt: Sensoray 2250/2251 support                                                                                                                       │  
#  │   Location:                                                                                                                                              │  
#  │     -> Device Drivers                                                                                                                                    │  
#  │       -> Multimedia support (MEDIA_SUPPORT [=m])                                                                                                         │  
#  │ (4)     -> Media USB Adapters (MEDIA_USB_SUPPORT [=y])                                                                                                   │  
#  │   Defined at drivers/media/usb/go7007/Kconfig:44                                                                                                         │  
#  │   Depends on: MEDIA_SUPPORT [=m] && MEDIA_USB_SUPPORT [=y] && MEDIA_ANALOG_TV_SUPPORT [=y] && VIDEO_GO7007_USB [=n] && USB [=y]                          │  
#  │                                                                                                                                                          │  
#  │                                                                                                                                                          │  
#  │ Symbol: VIDEO_SAA7134_GO7007 [=n]                                                                                                                        │  
#  │ Type  : tristate                                                                                                                                         │  
#  │ Prompt: go7007 support for saa7134 based TV cards                                                                                                        │  
#  │   Location:                                                                                                                                              │  
#  │     -> Device Drivers                                                                                                                                    │  
#  │       -> Multimedia support (MEDIA_SUPPORT [=m])                                                                                                         │  
#  │         -> Media PCI Adapters (MEDIA_PCI_SUPPORT [=y])                                                                                                   │  
#  │ (5)       -> Philips SAA7134 support (VIDEO_SAA7134 [=m])                                                                                                │  
#  │   Defined at drivers/media/pci/saa7134/Kconfig:67                                                                                                        │  
#  │   Depends on: PCI [=y] && MEDIA_SUPPORT [=m] && MEDIA_PCI_SUPPORT [=y] && (MEDIA_ANALOG_TV_SUPPORT [=y] || MEDIA_DIGITAL_TV_SUPPORT [=y]) && VIDEO_SAA71 │  
#  │ Symbol: VIDEO_TW9906 [=n]                                                                                                                                │  
#  │ Type  : tristate                                                                                                                                         │  
#  │ Prompt: Techwell TW9906 video decoder                                                                                                                    │  
#  │   Location:                                                                                                                                              │  
#  │     -> Device Drivers                                                                                                                                    │  
#  │ (1)   -> Multimedia support (MEDIA_SUPPORT [=m])                                                                                                         │  
#  │         -> I2C Encoders, decoders, sensors and other helper chips                                                                                        │  
#  │   Defined at drivers/media/i2c/Kconfig:427                                                                                                               │  
#  │   Depends on: MEDIA_SUPPORT [=m] && VIDEO_V4L2 [=m] && I2C [=y]                                                                                          │  
#  │   Selected by [n]:                                                                                                                                       │  
#  │   - VIDEO_GO7007 [=n] && MEDIA_SUPPORT [=m] && MEDIA_USB_SUPPORT [=y] && MEDIA_ANALOG_TV_SUPPORT [=y] && VIDEO_DEV [=m] && I2C [=y] && SND [=m] && USB [ │  
set -eE
set -u  # turn on strict variable checking
# debugging
#set -x  # trace all function calls

function failure() { local lineno=$1;  local msg=$2
  echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR ;#  trap [-lp] [[arg] sigspec ...], sigspec: ERR,EXIT,RETURN,DEBUG



START_DIR=$(pwd)
RPMBUILD_HOME=$(pwd)/rpmbuild
cd $RPMBUILD_HOME/BUILD/kernel-*/linux-*/

make --jobs=auto M=drivers/media/usb/go7007
find . -type f -name "go7007*.ko"
#make -j 4 M=drivers/media/i2c/tw9906 causes *** You are building kernel with non-retpoline compiler, please update your compiler..
#see: https://askubuntu.com/questions/1145943/building-kernel-with-non-retpoline-compiler
#Run make menuconfig. Navigate to Processor type and features, and uncheck Avoid speculative indirect branches in kernel.
make --jobs=auto M=drivers/media/i2c  #/tw9906
find . -type f -name "tw9906*.ko"

DRIVERS_ROOT=/lib/modules/`uname -r`/kernel

GO7007DIR=${DRIVERS_ROOT}/drivers/media/usb/go7007
if [ ! -d ${GO7007DIR} ]; then sudo mkdir -p ${GO7007DIR}; fi
for driverPath in $(find . -type f -name "go7007*.ko") ; do
    sudo cp -v $driverPath ${GO7007DIR}
done

TW9906DIR=${DRIVERS_ROOT}/drivers/media/i2c
if [ ! -d ${TW9906DIR} ]; then sudo mkdir -p ${TW9906DIR}; fi
sudo cp -v $(find . -name "tw9906.ko") ${TW9906DIR}

cd $START_DIR
sudo depmod -a # Initialize dependencies

#https://askubuntu.com/questions/14627/no-symbol-version-for-module-layout-when-trying-to-load-usbhid-ko
MODPOPT=
MOD_VERS=$(find . -name Module.symvers)
if [ "${#MOD_VERS}" == "0" ]; then
  # Module.symvers not found
  # NOTE: "modules_prepare" will not build Module.symvers even if
  # CONFIG_MODVERSIONS is set; therefore, a full kernel build needs to be
  # executed to make module versioning work.
  MODPOPT="--force";#  -f, --force  Force module insertion or removal. Implies --force-modversions and --force-vermagic
fi
## VIDEO_TW9906 [=n] │ Prompt: Techwell TW9906 video decoder  
# Location:  -> Device Drivers 
#                -> Multimedia support (MEDIA_SUPPORT [=m]) 
#                   -> I2C Encoders, decoders, sensors and other helper chips  
sudo modprobe $MODPOPT tw9906 
sudo modprobe $MODPOPT go7007
sudo modprobe $MODPOPT go7007-usb
sudo modprobe $MODPOPT go7007-loader
modprobe -D go7007           # print module dependencies

#sudo setenforce 0
# put the usb in
#sudo setenforce 1

dmesg | grep video

# | modprobe -D go7007
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/v4l2-core/videodev.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/v4l2-core/v4l2-common.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/sound/soundcore.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/sound/core/snd.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/sound/core/snd-timer.ko.xz 
# | install /sbin/modprobe --ignore-install snd-pcm && /sbin/modprobe snd-seq 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/common/videobuf2/videobuf2-common.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/common/videobuf2/videobuf2-v4l2.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/common/videobuf2/videobuf2-memops.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/common/videobuf2/videobuf2-vmalloc.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/usb/go7007/go7007.ko 
# | 
# | modprobe -D go7007-usb
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/v4l2-core/videodev.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/v4l2-core/v4l2-common.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/sound/soundcore.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/sound/core/snd.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/sound/core/snd-timer.ko.xz 
# | install /sbin/modprobe --ignore-install snd-pcm && /sbin/modprobe snd-seq 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/common/videobuf2/videobuf2-common.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/common/videobuf2/videobuf2-v4l2.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/common/videobuf2/videobuf2-memops.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/common/videobuf2/videobuf2-vmalloc.ko.xz 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/usb/go7007/go7007.ko 
# | insmod /lib/modules/4.18.0-240.1.1.el8_3.x86_64/kernel/drivers/media/usb/go7007/go7007-usb.ko 
# | 
