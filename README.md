# QACC-PC
Custom accent colour creator for Android 10 [Linux/macOS]

#### Introduction
Android 10 introduces an option to change the system accent colour. In pure AOSP, it is limited to certain preset colours(Custom ROMs may have more colours). What if you want to set your own accent colour? That's where this script comes into play. The script gets your choice of colours (along with a name) and creates an overlay targeting android (framework-res). A Magisk module is created by the app, which injects the created overlay to the system.

#### Requirements
* Linux or macOS
* apktool & Java
* xmlstarlet
* Android phone 
  * Running Android 10 
  * Rooted with Magisk
  * USB debugging enabled

#### Instructions
* Clone or download this repo.
* Open terminal in that folder.
* Connect your phone to PC.
* Run the script.
  * `chmod +x qacc.sh`
  * `./qacc.sh`

#### Note
* The script replaces the inbuilt Cinnamon accent colour with your custom colour.
* To remove the custom accent colour, remove the magisk module and reboot.