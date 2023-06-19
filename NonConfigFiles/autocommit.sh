#!/bin/bash
### Thanks to Eddie the engineer for providing examples on how to flash Klipper on different devices!!!

echo "Stopping Klipper..."
sudo service klipper stop
echo "Klipper has stopped"

### Flash Raspberry Pi linux Processor
echo "Start processing for Raspberry Pi"
make clean KCONFIG_CONFIG=config.rpi
make menuconfig KCONFIG_CONFIG=config.rpi
make flash  KCONFIG_CONFIG=config.rpi
if [ $? -eq 0 ]; then
   echo "*** Successfully flashed linux process for Raspberry Pi"
else
   echo "*** Unable to flash linux process for Raspberry Pi"
fi

echo
echo ----------------------------------------------------------
echo

### Flash the Spider v2.2 via USB...
echo "Start processing for the Spider 2.2..."
make clean KCONFIG_CONFIG=config.spider22
make menuconfig KCONFIG_CONFIG=config.spider22
make -j4 KCONFIG_CONFIG=config.spider22
make flash KCONFIG_CONFIG=config.spider22 FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_stm32f446xx_35004B001951373434353332-if00
# Sometimes the Octopus is stuck in DFU mode...
if [ $? -eq 0 ]; then
   echo "*** Successfully flashed Spider v2.2"
else
   echo "*** Unable to flash via serial path, attempting via USB device ID..."
   make flash KCONFIG_CONFIG=config.spider22 FLASH_DEVICE=0483:df11
fi

echo
echo ----------------------------------------------------------
echo

### Flash the SB2040 via CAN Boot...
#echo "Start processing for the Fly-sht36..."
make clean KCONFIG_CONFIG=config.sht36v2.7a268842af31
make menuconfig KCONFIG_CONFIG=config.sht36v2.7a268842af31
make -j4 KCONFIG_CONFIG=config.sht36v2.7a268842af31
python3 ~/CanBoot/scripts/flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u 7a268842af31


### Flash the SB2040 via CAN Boot...
#echo "Start processing for the SB2040..."
#make clean KCONFIG_CONFIG=config.sb2040
#make menuconfig KCONFIG_CONFIG=config.sb2040
#make -j4 KCONFIG_CONFIG=config.sb2040
#python3 ~/CanBoot/scripts/flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u d063055012c2

echo "Starting Klipper..."
sudo service klipper start
echo "Klipper has started"