#!/bin/bash
### Thanks to Eddie the engineer for providing examples on how to flash Klipper on different devices!!!

cat << "EOF" 
----------------------------------------------------------------------------------------------------------------------------
 ____              _     _     _____           __  __  ____ _   _               _                          _       _
|  _ \  ___  _   _| |__ | | __|_   _|         |  \/  |/ ___| | | |   __ _ _   _| |_ ___    _   _ _ __   __| | __ _| |_ ___
| | | |/ _ \| | | | '_ \| |/ _ \| |    _____  | |\/| | |   | | | |  / _` | | | | __/ _ \  | | | | '_ \ / _` |/ _` | __/ _ \
| |_| | (_) | |_| | |_) | |  __/| |   |_____| | |  | | |___| |_| | | (_| | |_| | || (_) | | |_| | |_) | (_| | (_| | ||  __/
|____/ \___/ \__,_|_.__/|_|\___||_|           |_|  |_|\____|\___/   \__,_|\__,_|\__\___/   \__,_| .__/ \__,_|\__,_|\__\___|
----------------------------------------------------------------------------------------------------------------------------
EOF

echo "Stopping Klipper..."
sudo service klipper stop
echo "Klipper has stopped"

cat << "EOF" 
############################################################################################################################
 ____                 _                            ____  _
|  _ \ __ _ ___ _ __ | |__   ___ _ __ _ __ _   _  |  _ \(_)
| |_) / _` / __| '_ \| '_ \ / _ \ '__| '__| | | | | |_) | |
|  _ < (_| \__ \ |_) | |_) |  __/ |  | |  | |_| | |  __/| |
|_| \_\__,_|___/ .__/|_.__/ \___|_|  |_|   \__, | |_|   |_|
               |_|                         |___/
############################################################################################################################
EOF

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

cat << "EOF" 
############################################################################################################################
 ____        _     _                   ____    _____
/ ___| _ __ (_) __| | ___ _ __  __   _|___ \  |___ /
\___ \| '_ \| |/ _` |/ _ \ '__| \ \ / / __) |   |_ \
 ___) | |_) | | (_| |  __/ |     \ V / / __/ _ ___) |
|____/| .__/|_|\__,_|\___|_|      \_/ |_____(_)____/
      |_|
############################################################################################################################
EOF

### Flash the Spider v2.3 via USB...
echo "Start processing for the Spider 2.3..."
make clean KCONFIG_CONFIG=config.spider23
make menuconfig KCONFIG_CONFIG=config.spider23
make -j4 KCONFIG_CONFIG=config.spider23
make flash KCONFIG_CONFIG=config.spider23 FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_stm32f446xx_34005C001951303439363932-if00
# Sometimes the Octopus is stuck in DFU mode...
if [ $? -eq 0 ]; then
   echo "*** Successfully flashed Spider v2.3"
else
   echo "*** Unable to flash via serial path, attempting via USB device ID..."
   make flash KCONFIG_CONFIG=config.spider23 FLASH_DEVICE=0483:df11
fi

echo
echo ----------------------------------------------------------
echo

cat << "EOF" 
############################################################################################################################
 _____ _  __   __        _     _   _____  __           ____
|  ___| | \ \ / /    ___| |__ | |_|___ / / /_   __   _|___ \
| |_  | |  \ V /____/ __| '_ \| __| |_ \| '_ \  \ \ / / __) |
|  _| | |___| |_____\__ \ | | | |_ ___) | (_) |  \ V / / __/
|_|   |_____|_|     |___/_| |_|\__|____/ \___/    \_/ |_____|
############################################################################################################################
EOF


### Flash the Fly-sht36v2 via CAN Boot...
#echo "Start processing for the Fly-sht36v2..."
make clean KCONFIG_CONFIG=config.sht36v2.7a268842af31
make menuconfig KCONFIG_CONFIG=config.sht36v2.7a268842af31
make -j4 KCONFIG_CONFIG=config.sht36v2.7a268842af31
python3 ~/CanBoot/scripts/flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u 7a268842af31

echo
echo ----------------------------------------------------------
echo

cat << "EOF" 
############################################################################################################################
 _____ _             _____                       ____   ___  _  _    ___
|_   _(_)_ __  _   _|  ___|_ _ _ __    _ __ _ __|___ \ / _ \| || |  / _ \
  | | | | '_ \| | | | |_ / _` | '_ \  | '__| '_ \ __) | | | | || |_| | | |
  | | | | | | | |_| |  _| (_| | | | | | |  | |_) / __/| |_| |__   _| |_| |
  |_| |_|_| |_|\__, |_|  \__,_|_| |_| |_|  | .__/_____|\___/   |_|  \___/
               |___/                       |_|                     
############################################################################################################################
EOF  


### Flash the TinyFan RP2040 via CAN Boot...
#echo "Start processing for the SB2040..."
#make clean KCONFIG_CONFIG=config.tinyfan
#make menuconfig KCONFIG_CONFIG=config.tinyfan
#make -j4 KCONFIG_CONFIG=config.tinyfan
make flash KCONFIG_CONFIG=config.tinyfan FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_rp2040_E66138935F422C28-if00

echo "Starting Klipper..."
sudo service klipper start
echo "Klipper has started"