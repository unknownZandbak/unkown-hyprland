#!/bin/bash

# The follwoing will attempt to install all needed packages to run Hyprland
# This is a quick and dirty script there is no error checking
# This script is meant to run on a clean fresh "minimal" arch install

# Credits to SolDoesTech and his hyprland installer project: https://github.com/SolDoesTech/hyprland
# I took his script as basis for this project
# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"


####======== Check for yay ========####
if command -v yay &> /dev/null; then
    echo -e "Yay was located, updating system pakages and moving on.\n"
    yay -Syu
else
    echo -e "Yay was not located.\n"
    read -n1 -rep 'Would you like to install yay? (y,N) :: ' YAY
    if [[ $YAY == "Y" || $YAY == "y" ]]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm &>> ../$INSTLOG
        cd ..
    else
        echo -e "Yay is required for this script, please run the script again or install manualy."
        exit
    fi
fi

###======== Install the Rust toolchain  ========###
if command -v rustup &> /dev/null; then
    echo -e "Rustup detected, Moving on"
else
    echo -n1 -rep '[\e[1;33mACTION\e[0m] - Installing the Rust toolchain?, (Rust is needed for some of the pakages require rust as an dependecie).'
    sleep 1
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

###======== Install all of the pacakges ========####
DEP=( # Core dependencies hyprland on arch
    gdb
    ninja
    gcc
    cmake
    meson
    libxcb
    xcb-proto
    xcb-util
    xcb-util-keysyms
    libxfixes
    libx11
    libxcomposite
    xorg-xinput
    libxrender
    pixman
    wayland-protocols
    cairo
    pango
    seatd
    libxkbcommon
    xcb-util-wm
    xorg-xwayland
    libinput
    libliftoff
    libdisplay-info
    cpio
    tomlplusplus
    wireless_tools
    iwd
    wpa_supplicant
    openssh
    smartmontools
    wget
)
HYPR=(
    hyprland # The Hyprland Compositor
    sddm # Display manager
    qt5-wayland # Qt for wayland
    qt6-wayland # More Qt 
    waybar-hyprland # Waybar with Hyprland Support
    xdg-desktop-portal-hyprland # xdg-desktop-portal backend for hyprland
    xdg-utils # Extra tools to applications with desktop integration tasks
    polkit-kde-agent # needed to get superuser access on some graphical appliaction
    rofi-lbonn-wayland # A window switcher, run dialog and dmenu replacement
    kitty # Terminal emulator
    eww # ElKowars wacky widgets
    wired # Lightweight notification daemon with highly customizable layout blocks.
    swaybg # Set a desktop background image
    swww # Efficient animated walpaper daemon, with hotreloading
    waypaper # GUI wallpaper manager, with support for swaybg and swww backends
    hyprshot # Screenshot taker for wayland Compositors
    wlogout # Logout Menu
    swaylock-effects # Lets you lock your desktop, with some extra effects
    fish # My personaly preferred shell
    starship # cross-shell custom shell prompts
    cliphist # Clipboard manager supports both text and images
)
NET=(
    bluez # Bluetooth service
    bluez-utils # Command line utilities
    blueman # GUI Bluetooth manager
    networkmanager # Network manager
    network-manager-applet # for use in tray
)
AUDIO=(
    pipewire # Audio
    pipewire-audio # Audio
    pipewire-jack # Audio
    pipewire-alsa # Audio
    pipewire-pulse  # Audio
    gst-plugin-pipewire # Audio
    wireplumber # More audio
    pavucontrol # GUI for managing audio
    pamixer # Helps with audio settings, such as volume
)
UTIL=(
    pacman-contrib # adds additional tools for pacman. needed for showing system updates in the waybar
    htop # TUI Resource monitor
    nnn # TUI file Explorer
    file-roller # Backend set of tools for working with compressed files
    dolphin # Kde file manager
    ark # Archiver
    firefox # My Browser of choice
    visual-studio-code-bin # My editor of choice
    neovim # Terminal text editor
    neofetch # Popular system info fetcher
    brightnessctl # brightness control for laptop
    flatpak # Flatpaks Lets goooo
    appimagelauncher # Appimage manager
)
VIZ=(
    nwg-look # Tool for GTK settings
    qt5ct # Tool for Qt5 settings
    qt6ct # Tool for Qt6 settings
    ttf-jetbrains-mono-nerd
    ttf-firacode-nerd
    noto-fonts-emoji
    xfce4-settings # xfce tools, needed to set GTK theme
)

read -n1 -rep $'[\e[1;33mACTION\e[0m] - Would you like to install the packages? (y,N) :: ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then

    #======== Stage 0 ========#
    echo -e "\n$CNT - Stage 0 - Checking for core dependencies, this may take a while..."
    for SOFTWR in "${DEP[@]}"
    do
        #First lets see if the package is there
        if yay -Qs $SOFTWR > /dev/null ; then
            echo -e "$COK - $SOFTWR is already installed."
        else
            echo -e "$CNT - Now installing $SOFTWR ..."
            yay -S --noconfirm $SOFTWR &>> $INSTLOG
            if yay -Qs $SOFTWR > /dev/null ; then
                echo -e "$COK - $SOFTWR was installed."
            else
                echo -e "$CER - $SOFTWR install had failed, please check the install.log"
                exit
            fi
        fi
    done

    #======== Stage 1 ========#
    echo -e "\n$CNT - Stage 1 - Installing network/bluetooth components, this may take a while..."
    for SOFTWR in "${NET[@]}"
    do
        #First lets see if the package is there
        if yay -Qs $SOFTWR > /dev/null ; then
            echo -e "$COK - $SOFTWR is already installed."
        else
            echo -e "$CNT - Now installing $SOFTWR ..."
            yay -S --noconfirm $SOFTWR &>> $INSTLOG
            if yay -Qs $SOFTWR > /dev/null ; then
                echo -e "$COK - $SOFTWR was installed."
            else
                echo -e "$CER - $SOFTWR install had failed, please check the install.log"
                exit
            fi
        fi
    done

    #======== Stage 2 ========#
    echo -e "\n$CNT - Stage 2 - Installing pipewire and additional audio tools, this may take a while..."
    for SOFTWR in "${AUDIO[@]}"
    do
        #First lets see if the package is there
        if yay -Qs $SOFTWR > /dev/null ; then
            echo -e "$COK - $SOFTWR is already installed."
        else
            echo -e "$CNT - Now installing $SOFTWR ..."
            yay -S --noconfirm $SOFTWR &>> $INSTLOG
            if yay -Qs $SOFTWR > /dev/null ; then
                echo -e "$COK - $SOFTWR was installed."
            else
                echo -e "$CER - $SOFTWR install had failed, please check the install.log"
                exit
            fi
        fi
    done

    #======== Stage 3 ========#
    echo -e "\n$CNT - Stage 3 - Installing Hyprland and main components, this may take a while..."
    for SOFTWR in "${HYPR[@]}"
    do
        #First lets see if the package is there

        if yay -Qs $SOFTWR > /dev/null ; then
            echo -e "$COK - $SOFTWR is already installed."
        else
            echo -e "$CNT - Now installing $SOFTWR ..."
            yay -S --noconfirm $SOFTWR &>> $INSTLOG
            if yay -Qs $SOFTWR > /dev/null ; then
                echo -e "$COK - $SOFTWR was installed."
            else
                echo -e "$CER - $SOFTWR install had failed, please check the install.log"
                exit
            fi
        fi
      done

      #======== Stage 4 ========#
      echo -e "\n$CNT - Stage 4 - Installing additional tools and utilities, this may take a while..."
      for SOFTWR in "${UTIL[@]}"
      do
          #First lets see if the package is there

          if yay -Qs $SOFTWR > /dev/null ; then
              echo -e "$COK - $SOFTWR is already installed."
          else
              echo -e "$CNT - Now installing $SOFTWR ..."
              yay -S --noconfirm $SOFTWR &>> $INSTLOG
              if yay -Qs $SOFTWR > /dev/null ; then
                  echo -e "$COK - $SOFTWR was installed."
              else
                  echo -e "$CER - $SOFTWR install had failed, please check the install.log"
                  exit
              fi
          fi
      done

    #======== Stage 5 ========#
    echo -e "\n$CNT - Stage 5 - Installing theme and visual related tools and utilities, this may take a while..."
    for SOFTWR in "${VIZ[@]}"
    do
        #First lets see if the package is there
        if yay -Qs $SOFTWR > /dev/null ; then
            echo -e "$COK - $SOFTWR is already installed."
        else
            echo -e "$CNT - Now installing $SOFTWR ..."
            yay -S --noconfirm $SOFTWR &>> $INSTLOG
            if yay -Qs $SOFTWR > /dev/null ; then
                echo -e "$COK - $SOFTWR was installed."
            else
                echo -e "$CER - $SOFTWR install had failed, please check the install.log"
                exit
            fi
        fi
    done

    # Enable the bluetooth service
    echo -e "$CNT - Starting the Bluetooth Service..."
    sudo systemctl enable --now bluetooth.service &>> $INSTLOG
    sleep 2

    # Enable the ly login manager service
    echo -e "$CNT - Enabling the SDDM Service..."
    sudo systemctl enable sddm &>> $INSTLOG
    sleep 2

    # Clean out other portals
    echo -e "$CNT - Cleaning out conflicting xdg portals..."
    yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk &>> $INSTLOG
fi


###======== Copy Config Files ========###
read -n1 -rep '[\e[1;33mACTION\e[0m] - Would you like to copy config files? (y,N) :: ' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
    echo -e "Copying config files...\n"
    cp -R hypr ~/.config/
    cp -R fish ~/.config/
    cp -R kitty ~/.config/
    cp -R waybar ~/.config/
    cp -R swaylock ~/.config/

    # Set some files as exacutable
    echo -e "$CNT - Setting some file as executable."
    chmod +x ~/.config/hypr/scripts/bgaction
    chmod +x ~/.config/hypr/scripts/xdg-portal-hyprland
    chmod +x ~/.config/waybar/scripts/waybar-wttr.py
    chmod +x ~/.config/waybar/scripts/baraction
    chmod +x ~/.config/waybar/scripts/update-sys

    # copy destop info to wayland sessions
    sudo cp hypr/hyprland.desktop /usr/share/wayland-sessions/
fi

###======== Script is done ========###
echo -e "Setup had completed.\n"
echo -e "You can now start using Hyprland, Note some services or packages might not work correctly until a reboot."
read -n1 -rep 'Would you like to use Hyprland now? esle the system will reboot (y,N) :: ' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
    sudo systemctl start sddm
fi
