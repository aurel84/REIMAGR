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

### RECOMMENDED / REQUIRED APPLICATIONS ###
1.) Install macOS Catalina.app <- Get it here: https://apps.apple.com/us/app/macos-catalina/id1466841314?ls=1&mt=12

2.) PLIST files for User Customizations:
    
- macOS Dock <- Open 'Go To Folder', paste the following: '~/Library/Preferences/' > 
    locate 'com.apple.dock.plist' > copy/paste it the following location: '/Volumes/REIMAGR/Customizations/Dock/'

- macOS LoginWindow <- Open 'Go To Folder', paste the following: '/Library/Preferences/' >
    locate 'com.apple.loginwindow.plist' > copy/paste it to the following location: '/Volumes/REIMAGR/Customizations/LoginWindow/'
    
3.) Wallpaper, Profile Picture, and Bookmarks:

- Wallpaper <- Grab any Wallpaper that you want to set as the default for all users >
place the Wallpaper in the following location: '/Volumes/REIMAGR/Customizations/Wallpaper/'

- Profile Picture(s) < - Grab any Profile pictures that you want to have preinstalled with the image >
place these images in the following location: '/Volumes/REIMAGR/Customizations/My Profile Picture'

- Bookmarks <- Grab Apple Bookmark files (.webloc extensions) that you want to have preinstalled with the image >
place these bookmark files in the following locatino: '/Volumes/REIMAGR/Customizations/Bookmarks/'


