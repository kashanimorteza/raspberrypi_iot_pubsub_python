#!/bin/bash

#---------------------------------------------------------------------------------Variable
#-----------------------------Color
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
ENDCOLOR="\033[0m"
LINE0="-----"
LINE1="-----------"
LINE2=$LINE1$LINE1
LINE3=$LINE2$LINE2
LINE4=$LINE3$LINE3

#-----------------------------Variable
path="$( cd "$(dirname "$0")" ; pwd -P )"
config_file=$path/config.yaml
api_sh=$path/api.sh
name=$(yq '.general.name' $config_file)
name=$(echo "$name" | tr -d '"')


#---------------------------------------------------------------------------------menu
#--------------------menu_main
menu_main()
{
    clear
    while true; do
        getHeader
        echo -e  ${YELLOW}"1)  ${GREEN}All" ${ENDCOLOR}
        echo -e  ${YELLOW}"2)  ${GREEN}Install" ${ENDCOLOR}
        echo -e  ${YELLOW}"3)  ${GREEN}Service" ${ENDCOLOR}
        echo -e "${YELLOW}${LINE2}${ENDCOLOR}"
        echo -e  ${YELLOW}"q)  ${GREEN}Exit"    ${ENDCOLOR}
        read -p "Enter your choice [1-6]: " choice
        case $choice in
            1)  clear && all;;
            2)  clear && menu_install;;
            3)  clear && menu_service;;
            q)  clear && exit;;
            *)  exit;;
        esac
        echo -e "\n"
    done
}

#--------------------menu_install : 1
menu_install()
{
    clear
    while true; do
        getHeader
        echo -e  ${YELLOW}${LINE2}Install        ${ENDCOLOR}
        echo -e  ${YELLOW}"1)  ${GREEN}All"      ${ENDCOLOR}
        echo -e  ${YELLOW}${LINE2}               ${ENDCOLOR}
        read -p "Enter your choice [0-7]: " choice
        case $choice in    
            1)  clear && install_all;;
            *)  menu_main;;
        esac
        echo -e "\n"
    done
}

#--------------------menu_service : 2
menu_service()
{
    clear
    while true; do
        getHeader
        echo -e  ${YELLOW}${LINE2}Services         ${ENDCOLOR}
        echo -e  ${BLUE}"${LINE1}All"              ${ENDCOLOR}
        echo -e  ${YELLOW}"1)  ${GREEN}Create"     ${ENDCOLOR}
        echo -e  ${YELLOW}"2)  ${GREEN}Status"     ${ENDCOLOR}
        echo -e  ${YELLOW}"3)  ${GREEN}Stop"       ${ENDCOLOR}
        echo -e  ${YELLOW}"4)  ${GREEN}Restart"    ${ENDCOLOR}
        echo -e  ${BLUE}"${LINE1}GPIO-subscriber"  ${ENDCOLOR}
        echo -e  ${YELLOW}"5)  ${GREEN}Create"     ${ENDCOLOR}
        echo -e  ${YELLOW}"6)  ${GREEN}Restart"    ${ENDCOLOR}
        echo -e  ${YELLOW}"7)  ${GREEN}Status"     ${ENDCOLOR}
        echo -e  ${YELLOW}"8)  ${GREEN}Monitor"    ${ENDCOLOR}
        echo -e  ${YELLOW}"9)  ${GREEN}Stop"       ${ENDCOLOR}
        echo -e  ${YELLOW}${LINE2}                 ${ENDCOLOR}
        read -p "Enter your choice [1-35]: " choice
        case $choice in
            1)  clear && service_create_all;;
            2)  clear && service_status_all;;
            3)  clear && service_stop_all;;
            4)  clear && service_restart_all;;
            5)  clear && service_create_gpio_subscriber ;;
            6)  clear && systemctl restart $name"_"gpio_subscriber.service;;
            7)  clear && systemctl status $name"_"gpio_subscriber.service;;
            8)  clear && journalctl -n 100 -u $name"_"gpio_subscriber.service -f;;
            9)  clear && systemctl stop $name"_"gpio_subscriber.service;;
            q)  clear && menu_main;;
            *)  menu_main ;;
        esac
        echo -e "\n"
    done
}

#---------------------------------------------------------------------------------api_interface
api_interface()
{
    if [  "$1" == "install" ]; then all; fi
}

#---------------------------------------------------------------------------------Actions
source $api_sh
cd $path
if [  "$1" == "" ]; then menu_main; fi
if [  "$1" != "" ]; then api_interface $1 $2 $3 $4 $5; fi