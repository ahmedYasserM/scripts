#!/usr/bin/env bash

#|---/ /+-------------------------------------+---/ /|#
#|--/ /-| Standalone NVIDIA Driver Setup Script |--/ /-|#
#|-/ /--| (Extracted from Main Installation)    |-/ /--|#
#|/ /---+-------------------------------------+/ /---|#

# Exit immediately if a command exits with a non-zero status
set -e

## ----------------------------------------------------
## PLACEHOLDER FUNCTIONS (MOCKING global_fn.sh)
## NOTE: In a real environment, replace these with the actual
## contents of your 'global_fn.sh' file, or ensure it is sourced.
## ----------------------------------------------------

# Mocks the print_log function for logging messages
print_log() {
    local color=""
    local msg=""
    local bold=""
    local reset="\033[0m"

    # Simple argument parsing for demonstration
    while [[ $# -gt 0 ]]; do
        case "$1" in
        -r) color="\033[31m" ;;            # red
        -g) color="\033[32m" ;;            # green
        -y) color="\033[33m" ;;            # yellow
        -b) color="\033[34m" ;;            # blue
        -c) color="\033[36m" ;;            # cyan
        -warn) color="\033[33;1m[WARN]" ;; # yellow bold
        -stat) color="\033[32;1m[STAT]" ;; # green bold
        -crit) color="\033[31;1m[CRIT]" ;; # red bold
        -n) bold="\033[1m" ;;
        *) msg+="$1 " ;;
        esac
        shift
    done
    echo -e "${bold}${color}${msg}${reset}" >&2
}

# Placeholder for nvidia_detect (Actual logic is required here)
nvidia_detect() {
    # Check if a known NVIDIA module is loaded or card is present
    if lspci -k | grep -E "VGA|3D" | grep -q "NVIDIA"; then
        # The function must handle the '--drivers' and '--verbose' flags
        if [[ "$1" == "--drivers" ]]; then
            # Echo common Arch NVIDIA packages for the list
            echo "nvidia-utils"
            echo "nvidia"
            return 0
        elif [[ "$1" == "--verbose" ]]; then
            print_log -n "[NVIDIA] " -stat "Status :: " "NVIDIA GPU detected and ready for driver setup."
            return 0
        fi
        return 0 # True: NVIDIA card detected
    else
        if [[ "$1" == "--verbose" ]]; then
            print_log -n "[NVIDIA] " -stat "Status :: " "No NVIDIA GPU detected."
        fi
        return 1 # False: No NVIDIA card detected
    fi
}

## ----------------------------------------------------
## CONFIGURATION VARIABLES
## ----------------------------------------------------

# Determine the script directory
scrDir="$(dirname "$(realpath "$0")")"

# Flag to enable/disable NVIDIA actions (Default to 1: Enabled)
flg_Nvidia=${flg_Nvidia:-1}

# Assume the package list file path is known
install_pkg_lst="${scrDir}/install_pkg.lst"

# For demonstration, ensure the package list file exists and has the marker
if [ ! -f "${install_pkg_lst}" ]; then
    echo "# core packages" >"${install_pkg_lst}"
    echo -e "\n#user packages" >>"${install_pkg_lst}"
fi

# ===================================================================
# Main Logic: NVIDIA Driver and Header Package Inclusion
# ===================================================================

print_log -c "NVIDIA Setup :: " "Starting package preparation."

if nvidia_detect; then
    if [ "${flg_Nvidia}" -eq 1 ]; then
        print_log -g "Nvidia" "Detected :: " "Adding drivers and headers to package list."

        # 1. Add kernel headers (necessary for DKMS/module build)
        # Assuming the standard Arch Linux path for kernel pkgbase
        cat /usr/lib/modules/*/pkgbase 2>/dev/null | while read -r kernel; do
            print_log -stat "Nvidia" "Adding ${kernel}-headers"
            echo "${kernel}-headers" >>"${install_pkg_lst}"
        done

        # 2. Add the core NVIDIA driver packages
        nvidia_detect --drivers >>"${install_pkg_lst}"
    else
        print_log -warn "Nvidia" "Nvidia GPU detected but explicitly ignored (flg_Nvidia=0)."
    fi
else
    print_log -stat "Nvidia" "Not Detected :: " "No NVIDIA GPU found."
fi

# Display final verbose status
nvidia_detect --verbose

print_log -g "NVIDIA Setup :: " "Finished package preparation."
