#!/bin/bash

if [ "$EUID" -eq 0 ]; then
  echo -e "\033[33mRun the script as a regular user (without sudo)\033[0m"
  exit 1
fi

SCRIPT_LOCATION="$(cd "$(dirname "$0")" && pwd)"
shopt -s nullglob
OTHERCONFS=$(for f in /etc/keyd/*.conf; do [ "$(basename "$f")" = "Function-keys.conf" ] && continue; basename "$f"; done)
shopt -u nullglob
FILES=(
    "custom-keybindings.dconf"
    "launchers-media-system.dconf"
    "window-management.dconf"
    "navigation-screenshots.dconf"
    "Function-keys.conf"
    "blur-my-shell.dconf"
    "arc-menu.dconf"
    "dash-to-panel.dconf"
)
status="success"

DISTRO="debian/ubuntu"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        arch)
            DISTRO="arch"
            ;;
        fedora)
            DISTRO="fedora"
            ;;
        debian|ubuntu)
            DISTRO="debian/ubuntu"
            ;;
        *)
            DISTRO="debian/ubuntu"
            ;;
    esac
fi

if [ "$DISTRO" = "arch" ]; then
	MENUCHECK="pacman -Q gnome-menus"
	KEYDCHECK="pacman -Q keyd"
	MENUINSTALL="sudo pacman -S --noconfirm gnome-menus"
	KEYDINSTALL="sudo pacman -S --noconfirm keyd"
fi
if [ "$DISTRO" = "fedora" ]; then
	MENUCHECK="dnf list installed gnome-menus"
	KEYDCHECK="dnf list installed keyd"
	MENUINSTALL="sudo dnf install -y gnome-menus"
	KEYDINSTALL="sudo dnf -y copr enable alternateved/keyd && sudo dnf install -y keyd"
fi
if [ "$DISTRO" = "debian/ubuntu" ]; then
	MENUCHECK="dpkg-query -s gnome-menus gir1.2-gnomemenu-3.0"
	KEYDCHECK="dpkg-query -s keyd"
	MENUINSTALL="sudo apt install -y gnome-menus gir1.2-gnomemenu-3.0"
	KEYDINSTALL="sudo apt install -y keyd"
fi

IS_BLUR_INSTALLED=$(gnome-extensions list | grep -q blur-my-shell@aunetx)
BLUR_STATUS=$?

IS_ARC_INSTALLED=$(gnome-extensions list | grep -q arcmenu@arcmenu.com)
ARC_STATUS=$?

IS_DTP_INSTALLED=$(gnome-extensions list | grep -q dash-to-panel@jderose9.github.com)
DTP_STATUS=$?

if [[ $BLUR_STATUS -ne 0 ]]; then
        echo -e "\033[33mBlur my Shell is not installed.\033[0m"
    fi
    if [[ $ARC_STATUS -ne 0 ]]; then
        echo -e "\033[33mArc Menu is not installed.\033[0m"
    fi
    if [[ $DTP_STATUS -ne 0 ]]; then
        echo -e "\033[33mDash to Panel is not installed.\033[0m"
    fi

for file in "${FILES[@]}"; do
    if [ ! -f "$SCRIPT_LOCATION/$file" ]; then
        status="MISSINGFILE"
        break
    fi
done

    # Apply dconf settings
    dconf load '/org/gnome/settings-daemon/plugins/media-keys/' < "$SCRIPT_LOCATION/launchers-media-system.dconf"
    dconf load '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/' < "$SCRIPT_LOCATION/custom-keybindings.dconf"
    dconf load '/org/gnome/desktop/wm/keybindings/' < "$SCRIPT_LOCATION/window-management.dconf"
    dconf load '/org/gnome/shell/keybindings/' < "$SCRIPT_LOCATION/navigation-screenshots.dconf"
    if [[ $DTP_STATUS -eq 0 ]]; then
    dconf load '/org/gnome/shell/extensions/dash-to-panel/' < "$SCRIPT_LOCATION/dash-to-panel.dconf"
    fi
    if [[ $ARC_STATUS -eq 0 ]]; then
    dconf load '/org/gnome/shell/extensions/arcmenu/' < "$SCRIPT_LOCATION/arc-menu.dconf"
    fi
    if [[ $BLUR_STATUS -eq 0 ]]; then
    dconf load '/org/gnome/shell/extensions/blur-my-shell/' < "$SCRIPT_LOCATION/blur-my-shell.dconf"
    fi
        if ! bash -c "$MENUCHECK" &>/dev/null; then
        
            $MENUINSTALL
    	fi
    	if [ $? -ne 0 ]; then
            echo -e "\e[31mAn error occurred, Arc Menu dependencies were not installed.\e[0m"
    	status="error"
    	fi
        # Install keyd
        if ! bash -c "$KEYDCHECK" &>/dev/null; then
            $KEYDINSTALL
        fi
        
        if [ $? -ne 0 ]; then
            echo -e "\e[31mAn error occurred. keyd was not installed.\e[0m"
            	status="error"
        else

	if [ -n "$OTHERCONFS" ]; then
        echo "Existing keyd configs found:"
        echo -e "\033[33m$OTHERCONFS\033[0m"
        read -p "Overwrite? [y/N]: " CONFIRM
	if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            sudo rm -rf /etc/keyd/*
            sudo cp "$SCRIPT_LOCATION/Function-keys.conf" /etc/keyd/
            sudo systemctl enable keyd
            sudo systemctl restart keyd
            echo -e "\e[32mkeyd configured.\e[0m"
	else
	    echo "Operation cancelled"
fi
	else
	sudo rm -rf /etc/keyd/*
	sudo cp "$SCRIPT_LOCATION/Function-keys.conf" /etc/keyd/
        sudo systemctl enable keyd
        sudo systemctl restart keyd
        echo -e "\e[32mkeyd configured.\e[0m"
fi
fi
        
if [ "$status" = "MISSINGFILE" ]; then
    echo -e "\e[31mERROR: Missing required file(s). Settings may not be fully applied.\e[0m" >&2
elif [ "$status" = "error" ]; then
    echo -e "\e[31mERROR: An error occurred during installation or configuration. Please check the logs.\e[0m" >&2
else
    echo -e "\e[32mConfiguration has been successfully applied.\e[0m"
fi
