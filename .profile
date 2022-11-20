# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

pathappend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

pathprepend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

# set PATH so it includes user's private bin if it exists
pathprepend "$HOME/bin"

# set PATH so it includes user's private bin if it exists
pathprepend "$HOME/.local/bin"

# set PATH so it includes kitty terminal emulator if it exists
pathappend "$HOME/.local/kitty.app/bin"

# set PATH so it includes Rust environment
pathappend "$HOME/.cargo/env"

# set PATH so it includes Java environment
pathappend "/usr/lib/jvm/default/bin"

# set PATH so it includes Perl environment
pathappend "/usr/bin/site_perl"
pathappend "/usr/bin/vendor_perl"
pathappend "/usr/bin/core_perl"

# export path to environmental variables set
export PATH

# export ESP-IDF location
export ESPIDF=/opt/esp-idf

# environment config
# get monitor names using: find /sys/devices -name "edid"
# other way to find names: xrandr --listmonitors
# temperature path according to: https://github.com/polybar/polybar/wiki/Module:-temperature
if [ $(uname -n) = "ERGO-PC" ]; then
    export MONITOR_PRIMARY="HDMI-A-0"
    export MONITOR_SECONDARY="HDMI-A-1"
    export TEMP_PATH_GPU="/sys/devices/pci0000:00/0000:00:03.1/0000:1c:00.0/hwmon/hwmon2/temp1_input"
    export TEMP_PATH_CPU="/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1/temp2_input"
elif [ $(uname -n) = "ERGO-LAPTOP" ]; then
    export MONITOR_PRIMARY="eDP"
    export MONITOR_SECONDARY="HDMI-A-0"
    export TEMP_PATH_GPU=""
    export TEMP_PATH_CPU="/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon3/temp1_input"
fi

source .env
