#!/bin/bash
ROOT_UID=0
THEME_DIR="/usr/share/grub/themes"
THEME_NAME=""
MAX_DELAY=20


# Prompt colors

CDEF=" \033[0m"                                     # default color
CCIN=" \033[0;36m"                                  # info color
CGSC=" \033[0;32m"                                  # success color
CRER=" \033[0;31m"                                  # error color
CWAR=" \033[0;33m"                                  # warning color
b_CDEF=" \033[1;37m"                                # bold default color
b_CCIN=" \033[1;36m"                                # bold info color
b_CGSC=" \033[1;32m"                                # bold success color
b_CRER=" \033[1;31m"                                # bold error color
b_CWAR=" \033[1;33m"  



# Prompts is like echo command, but with colors for information, warnings etc.
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;          # for success message
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;          # for error message
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;          # for warning message
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;          # for info message
    *)
    echo -e "$@"
    ;;
  esac
}

# Welcome message
  prompt -s " \n \t \t Oniichan wa Oshimai! GRUB theme \n \t \t \t by zenith-chan \n \n "   


function has_command() {
  command -v $1 > /dev/null
}

prompt -i "Would you like to have option menu under the boot menu?${CDEF}  (y/n): ${b_CWAR}${CDEF}"
read answer0

if [ "$answer0" = "y" ];then
  THEME_NAME="Onimai"
else
  THEME_NAME="Onimai_no_menu"
fi

prompt -i "Begin installation?${CDEF}  (y/n): ${b_CWAR}${CDEF}"
read answer
if [ "$answer" = "y" ];then
#checking for root access
prompt -w "\nChecking for root access..."
if [ "$UID" -eq "$ROOT_UID" ]; then
  # Create grub themes directory if not exists
  prompt -i "Checking for the existence of themes directory..."
  [[ -d ${THEME_DIR}/${THEME_NAME} ]] && rm -rf ${THEME_DIR}/${THEME_NAME}
  mkdir -p "${THEME_DIR}/${THEME_NAME}" 



  # Copying theme
  prompt -i "Installing ${THEME_NAME} theme..."
  cp -a ${THEME_NAME}/* ${THEME_DIR}/${THEME_NAME}
  
  
  
  
  
  # Setting Onimai theme
  prompt -i "Setting ${THEME_NAME} as default...\n"
  
  # Backup grub conf
  cp -an /etc/default/grub /etc/default/grub.bak
  
  grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub

  echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub




  


  prompt -i "\nUpdating GRUB config ...\n"
  # Update grub config
  echo -e "Updating grub config..."
  if has_command update-grub; then
    update-grub
  elif has_command grub-mkconfig; then
    grub-mkconfig -o /boot/grub/grub.cfg
  elif has_command grub2-mkconfig; then
    if has_command zypper; then
      grub2-mkconfig -o /boot/grub2/grub.cfg
    elif has_command dnf; then
      grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    fi
  fi

  # End of installation (onii-chan's too tho)
  prompt -s "\n \t \t Oniichan wa Oshimai Theme Installed! \n \t \t \t enjoy, onii-chan"

  

else

  # Error (need root)
  prompt -e "\n [ Error! ] -> Run as root  \n \n "

fi

else
  prompt -i "Exitinig ... "
fi




