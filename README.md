# REIMAGR
REIMGAR allows for building and deploying OS X Images with your own User Customization.  With REIMAGR, you can specify: 
Apps, Pkgs, Wallpaper, and Plists (for Dock and Login Window) to build your own custom image.  REIMAGR utilizes Mac OS X Installer (currently on Catalina) by leveraging it's tools to automate the imaging process.  

### RECOMMENDED EQUIPMENT ###
- USB Thumb Drive (3.0 or faster) with at least 64 GB of storage
- MacBook (any model) (technician device) <- the device that you will be creating your customizations on
- MacBook (any model) (client device) <- the device that you you will be reimaging and applying the customizations

### SETTING UP REIMAGR ###
1.) Prepping the USB Thumb Drive (done on a technician MacBook)
- Insert a USB Thumb Drive w/the recommended specs into the technician device
- Open Disk Utility > Select the USB Thumb Drive, which populates under External Devices >
- Select Erase > Name the USB REIMAGR > Select Journaled for File System > Select Erase

2.) Setting Up the Directory for REIMAGR (done on a technician MacBook)
- Unzip the contents of REIMAGR.zip somewhere on a technician's MacBook local Drive (Macintosh HD)
- Copy the files located in the unzipped REIMAGR folder to the ROOT directory of REIMAGR USB 
- REIMAGR's root directory should look like this:

Volumes > REIMAGR:
* Install macOS Catalina.app
* Apps
* Customizations
* Distributions 
* reimagr.command

### REQUIRED APPLICATIONS ###
1.) Install macOS Catalina.app (can be acquired two ways):

- Open App Store > search for macOS Catalina (Source: https://apps.apple.com/us/app/macos-catalina/id1466841314?ls=1&mt=12)
- Open Terminal > Type the following in Terminal: softwareupdate --fetch-full-installer --full-installer-version 10.15.x (Source: https://scriptingosx.com/2019/10/download-a-full-install-macos-app-with-softwareupdate-in-catalina/)

### CREATING YOUR CUSTOMIZED TEMPLATE ###
1.) On a Technician's computer, Create a Local Account, which will be used as a Template.

2.) Log into the Template Account, perform the following actions:
- Install Applications that do not come standard with MacOS Catalina
- Open Users & Groups, change any settings under Login Options
- Customize the Dock for the Template Account

3.) Insert the USB Thumb Drive for REIMAGR:
- DOCK | Go to: ~/Library/Preferences > Copy 'com.apple.dock.plist' >  paste it to /REIMAGR/Customizations/Dock
- LOGIN WINDOW | Go to: /Library/Preferences > Copy 'com.apple.loginwindow.plist' > paste it to /REIMAGR/Customizations/LoginWindow
- WALLPAPER | paste it to /REIMAGR/Customizations/Wallpaper
- BOOKMARKS | Open Safari > Go to Desired Website(s) > Drag the URL to /REIMAGR/Customizations/Bookmarks
