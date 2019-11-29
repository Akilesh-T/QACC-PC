#!/bin/bash

title="Custom accent colour creator for Android 10"
sub="- by Akilesh -"
COLUMNS=$(tput cols) 
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "%*s\n" $(((${#sub}+$COLUMNS)/2)) "$sub"
sleep "0.5"
echo " "

osType=$(uname)
case "$osType" in
        "Darwin")
        {
            echo "Running on macOS" 
        } ;;    
        "Linux")
        {
            echo "Running on Linux"
        } ;;
        *) 
        {
            echo "Unsupported OS, exiting"
            exit
        } ;;
esac

adb_ins=$(which adb)
if [ -z $adb_ins ]; then
  echo
  echo "adb not installed..."
  echo "download and install from the link below:"
  echo "https://developer.android.com/studio/releases/platform-tools"
  echo " "
  exit
fi    

apktool_ins=$(which apktool)
if [ -z $apktool_ins ]; then
  echo
  echo "apktool not installed..."
  echo "download and install from the link below:"
  echo "https://ibotpeaches.github.io/Apktool/install/"
  echo " "
  exit
fi    

java_ins=$(which java)
if [ -z $java_ins ]; then
  echo
  echo "java not installed..."
  echo "Install Java 1.8 or greater."
  echo " "
  exit
fi    

xml_ins=$(which xmlstarlet)
if [ -z $xml_ins ]; then
  echo
  echo "xmlstarlet not installed..."
  echo "Install it and try again."
  echo " "
  exit
fi    

echo "Plug in your device"
echo "Make sure USB Debugging is enabled"
echo " "
adb devices
echo " "
echo "If you see your device listed, press enter to start"; read
sdk=`adb shell getprop ro.build.version.sdk`

if [ $sdk -lt 29 ]; then
	echo "This script is only for Android 10."
	echo " "
	exit
fi

st="Starting the process"
printf "%*s\n" $(((${#st}+$COLUMNS)/2)) "$st"
echo ""

adb shell su -c cp /system/product/overlay/AccentColorCinnamon/AccentColorCinnamonOverlay.apk /storage/emulated/0/
adb pull /storage/emulated/0/AccentColorCinnamonOverlay.apk 
apktool d AccentColorCinnamonOverlay.apk -o ACC

echo ""
echo "You must give your custom accent colour as a hex code."
echo "Example: #183693"
echo ""
echo "You may choose the colour from here:"
echo "https://www.w3schools.com/colors/colors_picker.asp"
sleep "0.5"
echo ""

echo "Enter your colour code for light theme:"
read light

echo " "
echo "Enter your colour code for dark theme:"
read dark

echo " "
echo "Give a name to your colour:"
read name

echo ""
conf="Confirmation"
printf "%*s\n" $(((${#conf}+$COLUMNS)/2)) "$conf"
echo ""
echo "Colour for light theme: $light"
echo "Colour for dark theme: $dark"
echo "Name of the colour: $name"
echo ""

echo "Press e to exit."
echo "Press any other key to continue...."
read ans

if [ "$ans" != "${ans#[Ee]}" ]; then
    exit
fi

xml ed -L -u '/resources/color[@name="accent_device_default_dark"]' -v "$dark" ACC/res/values/colors.xml
xml ed -L -u '/resources/color[@name="accent_device_default_light"]' -v "$light" ACC/res/values/colors.xml
xml ed -L -u '/resources/string[@name="accent_color_cinnamon_overlay"]' -v "$name" ACC/res/values/strings.xml

apktool -c b ACC

echo ""
mm="Creating a Systemless Magisk module"
printf "%*s\n" $(((${#mm}+$COLUMNS)/2)) "$mm"
echo ""

cat << EOF > ACC/module.prop
id=qacc
name=Accent colour changer for Android 10
version=1.0
versionCode=1
author=Akilesh
description=Create your own accent colour!
EOF

adb shell su -c rm -f /storage/emulated/0/AccentColorCinnamonOverlay.apk
adb push ACC/dist/AccentColorCinnamonOverlay.apk /storage/emulated/0/
adb push ACC/module.prop /storage/emulated/0/

adb shell su -c mkdir -p /data/adb/modules/qacc/system/product/overlay/AccentColorCinnamon

adb shell su -c touch /data/adb/modules/qacc/update
adb shell su -c touch /data/adb/modules/qacc/auto_mount
adb shell su -c mv -f /storage/emulated/0/module.prop /data/adb/modules/qacc
adb shell su -c mv -f /storage/emulated/0/AccentColorCinnamonOverlay.apk /data/adb/modules/qacc/system/product/overlay/AccentColorCinnamon/

rm -rf ACC
rm -f AccentColorCinnamonOverlay.apk

echo "Done. Reboot now? (y/n)"
read reboot

if [ "$reboot" != "${reboot#[Yy]}" ]; then
    adb reboot
    echo
    pause
    exit
else
    echo
    pause
    exit
fi
