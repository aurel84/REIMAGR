#!/bin/bash

### Variables ###
USER=$(stat -f %Su "/dev/console")
deletedPath="/Volumes/REIMAGR/Apps/"

### function to convert apps to distributions pkgs, and finally copying them over to /Users/Shared/ ###
fCreatePackages() {

  echo "Using productbuild to convert Apps to distribution PKGS..."
  for items in /Volumes/REIMAGR/Apps/*
  do

    newPath=${items#$deletedPath}

    productbuild --component /Volumes/REIMAGR/Apps/"$newPath" /Applications/ /Volumes/REIMAGR/Deployments/"$newPath".pkg

  done

  echo "Done converting apps to distribution pkgs."

  /Volumes/reimagr.command

}

### function to copy distribution PKGS from REIMAGR to /Users/Shared in Local Drive ###
fCopyPKGStoLocal()  {

  echo "Copying distribution pkgs from REIMAGR to /Users/Shared..."
  rsync -av --progress /Volumes/REIMAGR/Deployments/* /Volumes/Macintosh\ HD/Users/Shared

  echo "Finished with this step."

  /Volumes/reimagr.command

}

### function to get the name of each distribution names and store them ###
fInstallPackages()  {

  for items in /Users/Shared/*
  do

    echo "--installpackage '$items'"

  done

}

### function to get the wallpaper in the wallpaper folder and store it ###
fWallapper()  {

  for wallpaper in /Volumes/REIMAGR/Customizations/Wallpaper/*
  do

    echo "$wallpaper"

  done

}

### function to wipe, re-image, and install applications ###
fWipeAndReimage() {

  CMD=$(echo "/Volumes/REIMAGR/Install macOS"*.app/Contents/Resources/startosinstall --agreetolicense --nointeraction $(fInstallPackages) --eraseinstall)

  echo
  echo "This action will WIPE and REIMAGE this MacBook.  All data will be erased."
  echo "Do you want to continue?"
  echo "    1  Yes : WIPE and REIMAGE this MacBook."
  echo "    2  No  : Cancel the request."
  read -r -p "Pick an action # (1-2): " CONFIRMWIPE

  case $CONFIRMWIPE in
      1 ) eval "$CMD" ;;
      2 ) /Volumes/reimagr.command ;;
  esac

}

### function to load the customized Dock, Wallpaper, admin profile picture for Ultragenyx ###
fDefaultDockAndDesktop() {

  echo "Updating the Dock settings for all users..."
  cp /Volumes/MAC_FILES/Appearance/Dock/com.apple.dock.plist /Volumes/Macintosh\ HD/System/Library/User\ Template/English.lproj/Library/Preferences/

  echo "Renaming the default wallpaper for Catalina to Catalina.orignal.heic..."
  mv /Volumes/Macintosh\ HD/System/Library/Desktop\ Pictures/Catalina.heic /Volumes/Macintosh\ HD/System/Library/Desktop\ Pictures/Catalina.original.heic

  echo "Copying the wallpaper from REIMAGR to MAC OSX and naming it Catalina.heic..."
  rsync -av --progress /Volumes/REIMAGR/Customizations/Wallpaper/"$(fWallpaper)" /Volumes/Macintosh\ HD/System/Library/Desktop\ Pictures/Catalina.heic

  echo "Finished with customizations."

  /Volumes/reimagr.command

}

### function to run check disk, and run first aid if necessary ###
fRunFirstAid() {

  checkVolume=$(diskutil verifyVolume / | grep "0"; echo $?)

  diskutil verifyVolume /

  if [ "$checkVolume" != 0 ]; then

    echo "Finished scanning Volume, permissions appear to be OK";
    /Volumes/reimagr.command

  else

    diskutil repairVolume /;

    echo "Finished with this step."

    /Volumes/reimagr.command

  fi

  echo "Finished with this step."

  /Volumes/reimagr.command

}

### function to reboot the MacBook, either from Recovery or from user mode ###
fReboot() {

  echo "Checking for environment..."
  if [ "$USER" = "_windowserver" ]; then

    echo "Rebooting from recovery..."
    shutdown -r now

  else

    echo "Reboting from desktop..."
    osascript -e 'tell application "System Events" to restart'

  fi

}

### function to show author and credits ###
fCredits()  {

  echo
  echo " ########################################################################################### "
  echo " ############################# Author and Credits ########################################## "
  echo " ########################################################################################### "
  echo
  echo " Author: John Hawkins | Email: johnhawkins3d@gmail.com"
  echo
  echo " Other Contributors: The portion of this script that runs the wipe routine was..."
  echo " ...modified from Greg Neagle's Installr.sh: https://github.com/munki/installr   "
  echo

  /Volumes/reimagr.command

}

### function to exit terminal, either from Recovery or from user mode ###
fExit() {

  echo "Exiting Terminal..."
  killall Terminal

}

# text-only options prompt in terminal
echo
echo " ########################################################################################### "
echo " ################################ WECOME TO REIMAGR ######################################## "
echo " ################# By: John Hawkins | Contact: johnhawkins3d@gmail.com ##################### "
echo " ######################### PLEASE RTFM BEFORE RUNNING THE SCRIPT ########################### "
echo " ########################################################################################### "
echo
echo " Please make a selection below:"
echo "    1  Convert Apps in REIMAGR App folder to Distro pkgs <-- Run in Desktop Mode ########### "
echo "    2  Copy Distro PKGS from REIMAGR to MAC OSX Volume <---- Run in Desktop Mode ########### "
echo "    3  Wipe & Reimage MacBook, and install all Apps <------- Run in Desktop Mode ########### "
echo "    4  Update the Default Desktop Wallpaper and Dock <------ Run in Recovery Mode ########## "
echo "    5  Check integrity of MAC OSX Volume <------------------ Run in Desktop or Recovery Mode "
echo "    6  Reboot MAC OSX  <------------------------------------ Run in Desktop or Recovery Mode "
echo "    7  Authors and Credits <-------------------------------- Run in Desktop or Recovery Mode "
echo "    8  Exit script and close Terminal <--------------------- Run in Desktop or Recovery Mode "
echo
read -r -p "Pick an action # (1-8): " MAKESELECTION

# actions to be taken by the text only options above
case $MAKESELECTION in
    1 ) fCreatePackages ;;
    2 ) fCopyPKGStoLocal ;;
    3 ) fWipeAndReimage ;;
    4 ) fDefaultDockAndDesktop ;;
    5 ) fRunFirstAid ;;
    6 ) fReboot ;;
    7 ) fCredits ;;
    8 ) fExit ;;
esac
