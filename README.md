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
* Install macOS Catalina.app <- Place the OSX Installer in the Root Directory of REIMAGR
* Apps <----------------------- Where .app files and .pkg files go
* Customizations <------------- Directory for Wallpaper, Bookmarks, Dock, LoginWindow, Profile Pictures
* Distributions <-------------- REIMAGR converts .app and .pkg files from Apps and places them here
* reimagr.command <------------ The main script for REIMAGR, which is placed in the Root Directory

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

3.) Insert USB for REIMAGR into your Technician's Computer:
- Dock | Go to: ~/Library/Preferences > Copy 'com.apple.dock.plist' >  paste it to /REIMAGR/Customizations/Dock
- Login Window | Go to: /Library/Preferences > Copy 'com.apple.loginwindow.plist' > paste it to /REIMAGR/Customizations/LoginWindow
- Wallpaper | paste it to /REIMAGR/Customizations/Wallpaper
- Bookmarks | Open Safari > Go to Desired Website(s) > Drag the URL to /REIMAGR/Customizations/Bookmarks
- Profile Picture | Paste Picture(s) to /REIMAGR/Customizations/My Profile Pictures

### CREATING THE DISTRIBUTION PACKAGES FOR YOUR IMAGE ###
- Copy .app files from /Applications to /Volumes/REIMAGR/Apps
- Copy .pkg files to /Volumes/REIMAGR/Apps
- Run REIMAGR by launching /REIMAGR/reimagr.command > Select Option (1) to convert your applications to Distros
- Disconnect the USB for REIMAGR from the Technicians Computer

### HOW TO USE REIMAGR (STEPS BELOW CAN BE DONE ON MULTIPLE CLIENT DEVICES) ###
1.) Acquire a Client Devices to Run REIMAGR > Get to the Computer's Desktop
- Plug REIMAGR into the Client Device > Go to /Volumes/REIMAGR/reimagr.command
- If Transferring Applicaitons to Client Device, select Option (2)
- Once all Applications are transferred to Client Device, Select Option (3) to Wipe Device, then (1 to Confirm

#### ALL YOUR DATA WILL BE LOST.  YOU CANNOT UNDUE THIS STEP! ###

1.) After Wipe / Reimage process is complete, you will be at the Apple Setup Screen(s):
- Immediately Shut Down MacBook Book, then Power it Back on, holding (CMD) + (R) Keys to Boot into Recovery Mode >
- In Recovery Mode, Go to Utilities > Terminal >
- In Terminal, type the following Command: /Volumes/REIMAGR/startimage.command <enter >
- Select option (4) to Load Desktop Customizations onto the Client >
- Select option (5) to run First Aid (not required but recommended) >
- Select option (6) to Reboot Client MacBook.
  
2.) Go throug the Apple Setup Process.  After you have created a Local Account, you should be at the Desktop, and should see your Customizations and Installed Apps.  You are done with imaging steps, and the first account creation.  If you are configuring any further user accounts, the templates for them will also mirrior the first account, going forward.

