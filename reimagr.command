#!/bin/bash

### The language/region where defaults are loaded. ###
language="English.lproj" # Go to '/System/Library/User\ Template/', replace 'English.lproj' with another language.

### Variables ###
USER=$(stat -f %Su "/dev/console") # Get the logged in user.  Used to determine if action should be run in terminal or desktop.
pathToLanguage="${language}/Library/Preferences" # This is the path to to default settings for region.
deletedPath="/Volumes/REIMAGR/Apps/" # When for loop for items is done, it adds the path.  This subtracts the path.
startReimagr="/Volumes/REIMAGR/reimagr.command" # Restarts reimagr.command after an action is run.
pathToReimagr="Volumes/REIMAGR" # Path to reimagr root directory on USB.
pathToOSX="Volumes/Macintosh HD" # Path to User's Macintosh HD.

### function to convert apps to distributions pkgs, and finally copying them over to /Users/Shared/ ###
fCreateDistributions() {

  echo "Using productbuild to convert Apps or Components to Distribution PKGS..."
  for items in /"$pathToReimagr"/Apps/*
  do

    newPath=${items#*$deletedPath} # subtracts '/Volumes/REIMAGR/Apps/' from '/Volumes/REIMAGR/Apps/<Application.app>'

    if [[ $items == *.app ]]; then # checks if filetype ends with .app

      mkdir -p /"$pathToReimagr"/Apps/Component # make temp directory to store components

      echo "Converting $newPath to distribution package and placing it in /$pathToReimagr/Distributions"
      pkgbuild --component /"$pathToReimagr"/Apps/"$newPath" --install /Applications /"$pathToReimagr"/Apps/Component/TempComponent.pkg # places packages and components in temp directory
      productbuild --package /"$pathToReimagr"/Apps/Component/TempComponent.pkg /"$pathToReimagr"/Distributions/"$newPath".pkg # converts the package in the temp directory to a product

      echo "Removing temp component folder for $items"
      rm -r /"$pathToReimagr"/Apps/Component # remove temp directory after the app is converted to a distribution

    elif [[ $items == *.pkg ]]; then # checks if filetype ends with .pkg

      echo "Converting $newPath to distribution package and placing it in /$pathToReimagr/Distributions"
      pkgutil --expand /"$pathToReimagr"/Apps/"$newPath" /"$pathToReimagr"/Apps/Product_Flattened; # flattens the .pkg into a flat archive folder
      pkgutil --flatten /"$pathToReimagr"/Apps/Product_Flattened /"$pathToReimagr"/Distributions/"$newPath" # converts flat archive into a distribution pkg

      echo "Removing flat archive for $items"
      rm -r /"$pathToReimagr"/Apps/Product_Flattened # removes the flat archive folder

    fi

  done

  echo "Done converting Apps and Components to Distribution PKGS."

  $startReimagr

}

### function to copy distribution PKGS from REIMAGR to /Users/Shared in Local Drive ###
fCopyPKGStoLocal()  {

  echo "Copying distribution pkgs from REIMAGR to /Users/Shared..."
  rsync -av --progress /"$pathToReimagr"/Distributions/*.pkg /"$pathToOSX"/Users/Shared

  echo "Finished with this step."

  $startReimagr

}

### function to get the name of each distribution names and store them ###
fInstallPackages()  {

  packages=( /Users/Shared/*.pkg )
  for item in "${packages[@]}"
  do

    echo "--installpackage '$item'"

  done

}

### function to get the wallpaper in the wallpaper folder and store it ###
fWallpaper()  {

  for wallpaper in /"$pathToReimagr"/Customizations/Wallpaper/*
  do

    echo "$wallpaper"

  done

}

### function to determine if user has distribution packages in /Users/Shared, and starts startosinstall with the appropriate args ###
fstartOsInstall() {

  if ls /Users/Shared/*.pkg &> /dev/null; then

    echo "Found Distribution Packages in /Users/Shared.  Imaging this MacBook and installing Applications."
    eval "$(echo "/'$pathToReimagr'/Install"*.app/Contents/Resources/startosinstall --agreetolicense --nointeraction $(fInstallPackages) --eraseinstall)"

  else

    echo "No Distribution Packages in /Users/Shared.  Imaging this MacBook with only Default Applications."
    eval "$(echo "/'$pathToReimagr'/Install"*.app/Contents/Resources/startosinstall --agreetolicense --nointeraction --eraseinstall)"

  fi

}

### function to wipe, re-image, and install applications ###
fWipeAndReimage() {

  # CMD=$(echo "/'$pathToReimagr'/Install"*.app/Contents/Resources/startosinstall --agreetolicense --nointeraction $(fInstallPackages) --eraseinstall)

  echo
  echo "This action will WIPE and REIMAGE this MacBook.  All data will be erased."
  echo "Do you want to continue?"
  echo "    1  Yes : WIPE and REIMAGE this MacBook."
  echo "    2  No  : Cancel the request."
  read -r -p "Pick an action # (1-2): " CONFIRMWIPE

  case $CONFIRMWIPE in
      1 ) fstartOsInstall ;;
      2 ) startReimagr ;;
  esac

}

### function to load the customized Dock, Wallpaper, admin profile picture for Ultragenyx ###
fDefaultCustomizations() {

  # custom dock
  echo "Checking if there is a custom dock to be loaded onto image..."
  if [ "$(ls /"$pathToReimagr"/Customizations/Dock/*)" ]; then

    echo "Updating the Dock settings for all users."
    cp /"$pathToReimagr"/Customizations/Dock/com.apple.dock.plist /"$pathToOSX"/System/Library/User\ Template/"$pathToLanguage"/

  fi

  #custom login window
  echo "Checking if there is a custom Login Window to be loaded onto image..."
  if [ "$(ls /"$pathToReimagr"/Customizations/LoginWindow/*)" ]; then


    echo "Changing login window settings to display name and password"
    rm /"$pathToOSX"/Library/Preferences/com.apple.loginwindow.plist
    cp /"$pathToReimagr"/Customizations/LoginWindow/com.apple.loginwindow.plist /"$pathToOSX"/Library/Preferences/

  fi

  # custom bookmarks
  echo "Checking if there are any User-Specific Bookmarks to be loaded onto image..."
  if [ "$(ls /"$pathToReimagr"/Customizations/Bookmarks/*.webloc)" ]; then

    echo "Adding User Specific Bookmarks to /Users/Shared."
    cp -r /"$pathToReimagr"/Customizations/Bookmarks /"$pathToOSX"/Users/Shared/

  fi

  # custom wallpaper
  echo "Checking if there is is a custom wallpaper to be loaded onto image..."
  if [ "$(ls /"$pathToReimagr"/Customizations/Wallpaper/*)" ]; then

    echo "Yes, found one... renaming the default wallpaper for Catalina to Catalina.orignal.heic..."
    mv /"$pathToOSX"/System/Library/Desktop\ Pictures/Catalina.heic /"$pathToOSX"/System/Library/Desktop\ Pictures/Catalina.original.heic

    echo "Copying the wallpaper from REIMAGR to MAC OSX and naming it Catalina.heic."
    cp "$(fWallpaper)" /"$pathToOSX"/System/Library/Desktop\ Pictures/Catalina.heic

  fi

  # custom profile picture
  echo "Checking if there is is a custom profile picture to be loaded onto image..."
  if [ "$(ls /"$pathToReimagr"/Customizations/My\ Profile\ Picture/*)" ]; then

    echo "Copying the profile picture folder from REIMAGR to MAC OSX."
    cp -r /"$pathToReimagr"/Customizations/My\ Profile\ Picture /"$pathToOSX"/Library/User\ Pictures/

  fi

  echo "Finished with customizations."

  $startReimagr

}

### function to run check disk, and run first aid if necessary ###
fRunFirstAid() {

  checkVolume=$(diskutil verifyVolume / | grep "0"; echo $?)

  diskutil verifyVolume /

  if [ "$checkVolume" != 0 ]; then

    echo "Finished scanning Volume, permissions appear to be OK";

    echo "Finished with this step."

    $startReimagr

  else

    diskutil repairVolume /;

    echo "Finished with this step."

    $startReimagr

  fi

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
  echo " ######################################################################################### "
  echo " ############################# Author and Credits ######################################## "
  echo " ######################################################################################### "
  echo
  echo " Author: John Hawkins | Email: johnhawkins3d@gmail.com"
  echo
  echo " Credits: The portion of this script that runs the wipe routine was..."
  echo " ...modified from Greg Neagle's Installr.sh: https://github.com/munki/installr."
  echo

  $startReimagr

}

### function to exit terminal, either from Recovery or from user mode ###
fExit() {

  echo "Exiting Terminal..."
  killall Terminal

}

# text-only options prompt in terminal
echo
echo " ########################################################################################### "
echo " ################################ WELCOME TO REIMAGR ####################################### "
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
echo "    6  Reboot MAC OSX <------------------------------------- Run in Desktop or Recovery Mode "
echo "    7  Author and Credits <--------------------------------- Run in Desktop or Recovery Mode "
echo "    8  Exit script and close Terminal <--------------------- Run in Desktop or Recovery Mode "
echo
read -r -p "Pick an action # (1-8): " MAKESELECTION

# actions to be taken by the text only options above
case $MAKESELECTION in
    1 ) fCreateDistributions ;;
    2 ) fCopyPKGStoLocal ;;
    3 ) fWipeAndReimage ;;
    4 ) fDefaultCustomizations ;;
    5 ) fRunFirstAid ;;
    6 ) fReboot ;;
    7 ) fCredits ;;
    8 ) fExit ;;
esac
