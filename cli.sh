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
name=$(yq '.general.name' "$YAML_FILE")
echo "General name: $GENERAL_NAME"
exit

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
        echo -e  ${YELLOW}"4)  ${GREEN}Cron"    ${ENDCOLOR}
        echo -e  ${YELLOW}"5)  ${GREEN}Backup"  ${ENDCOLOR}
        echo -e  ${YELLOW}"6)  ${GREEN}Monitor" ${ENDCOLOR}
        echo -e "${YELLOW}${LINE2}${ENDCOLOR}"
        echo -e  ${YELLOW}"q)  ${GREEN}Exit"    ${ENDCOLOR}
        read -p "Enter your choice [1-6]: " choice
        case $choice in
            1)  clear && all;;
            2)  clear && menu_install;;
            3)  clear && menu_service;;
            4)  clear && menu_cron;;
            5)  clear && menu_backup;;
            6)  clear && monitor;;
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
        echo -e  ${YELLOW}"2)  ${GREEN}Update"   ${ENDCOLOR}
        echo -e  ${YELLOW}"3)  ${GREEN}Upgrade"  ${ENDCOLOR}
        echo -e  ${YELLOW}"4)  ${GREEN}Genaral"  ${ENDCOLOR}
        echo -e  ${YELLOW}"5)  ${GREEN}Nginx"    ${ENDCOLOR}
        echo -e  ${YELLOW}"6)  ${GREEN}Iptables" ${ENDCOLOR}
        echo -e  ${YELLOW}"6)  ${GREEN}Postgres" ${ENDCOLOR}
        echo -e  ${YELLOW}${LINE2}               ${ENDCOLOR}
        read -p "Enter your choice [0-7]: " choice
        case $choice in    
            1)  clear && install_all;;
            2)  clear && install_update;;
            3)  clear && install_upgrade;;
            4)  clear && install_general;;
            5)  clear && install_nginx;;
            6)  clear && install_iptables;;
            7)  clear && install_postgres;;
            q)  clear && menu_main;;
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
        echo -e  ${BLUE}"${LINE1}webapi"           ${ENDCOLOR}
        echo -e  ${YELLOW}"5)  ${GREEN}Create"     ${ENDCOLOR}
        echo -e  ${YELLOW}"6)  ${GREEN}Restart"    ${ENDCOLOR}
        echo -e  ${YELLOW}"7)  ${GREEN}Status"     ${ENDCOLOR}
        echo -e  ${YELLOW}"8)  ${GREEN}Monitor"    ${ENDCOLOR}
        echo -e  ${YELLOW}"9)  ${GREEN}Stop"       ${ENDCOLOR}
        echo -e  ${BLUE}"${LINE1}Nginx"            ${ENDCOLOR}
        echo -e  ${YELLOW}"10) ${GREEN}Create Api" ${ENDCOLOR}
        echo -e  ${YELLOW}"11) ${GREEN}Create Gui" ${ENDCOLOR}
        echo -e  ${YELLOW}"12) ${GREEN}Restart"    ${ENDCOLOR}
        echo -e  ${YELLOW}"13) ${GREEN}Status"     ${ENDCOLOR}
        echo -e  ${YELLOW}"14) ${GREEN}Monitor"    ${ENDCOLOR}
        echo -e  ${YELLOW}"15) ${GREEN}Stop"       ${ENDCOLOR}
        echo -e  ${BLUE}"${LINE1}Interrupt GPIO"   ${ENDCOLOR}
        echo -e  ${YELLOW}"16) ${GREEN}Create"     ${ENDCOLOR}
        echo -e  ${YELLOW}"17) ${GREEN}Restart"    ${ENDCOLOR}
        echo -e  ${YELLOW}"18) ${GREEN}Status"     ${ENDCOLOR}
        echo -e  ${YELLOW}"19) ${GREEN}Monitor"    ${ENDCOLOR}
        echo -e  ${YELLOW}"20) ${GREEN}Stop"       ${ENDCOLOR}
        echo -e  ${BLUE}"${LINE1}Interrupt 1W"     ${ENDCOLOR}
        echo -e  ${YELLOW}"21) ${GREEN}Create"     ${ENDCOLOR}
        echo -e  ${YELLOW}"22) ${GREEN}Restart"    ${ENDCOLOR}
        echo -e  ${YELLOW}"23) ${GREEN}Status"     ${ENDCOLOR}
        echo -e  ${YELLOW}"24) ${GREEN}Monitor"    ${ENDCOLOR}
        echo -e  ${YELLOW}"25) ${GREEN}Stop"       ${ENDCOLOR}
        echo -e  ${BLUE}"${LINE1}Cron min"         ${ENDCOLOR}
        echo -e  ${YELLOW}"26) ${GREEN}Create"     ${ENDCOLOR}
        echo -e  ${YELLOW}"27) ${GREEN}Restart"    ${ENDCOLOR}
        echo -e  ${YELLOW}"28) ${GREEN}Status"     ${ENDCOLOR}
        echo -e  ${YELLOW}"29) ${GREEN}Monitor"    ${ENDCOLOR}
        echo -e  ${YELLOW}"30) ${GREEN}Stop"       ${ENDCOLOR}
        echo -e  ${BLUE}"${LINE1}Other"            ${ENDCOLOR}
        echo -e  ${YELLOW}"31) ${GREEN}SApp ON"    ${ENDCOLOR}
        echo -e  ${YELLOW}"32) ${GREEN}SApp OFF"   ${ENDCOLOR}
        echo -e  ${YELLOW}"33) ${GREEN}Hotspod ON" ${ENDCOLOR}
        echo -e  ${YELLOW}"34) ${GREEN}Hotspod OFF"${ENDCOLOR}
        echo -e  ${YELLOW}"35) ${GREEN}Wifi Connect"${ENDCOLOR}
        echo -e  ${YELLOW}${LINE2}                 ${ENDCOLOR}
        read -p "Enter your choice [1-35]: " choice
        case $choice in
            1)  clear && service_create_all;;
            2)  clear && service_status_all;;
            3)  clear && service_stop_all;;
            4)  clear && service_restart_all;;
            5)  clear && service_create_webapi ;;
            6)  clear && systemctl restart $name"_"webapi.service;;
            7)  clear && systemctl status $name"_"webapi.service;;
            8)  clear && journalctl -n 100 -u $name"_"webapi.service -f;;
            9)  clear && systemctl stop $name"_"webapi.service;;
            10) clear && service_create_nginx_create_api;;
            11) clear && service_create_nginx_create_gui;;
            12) clear && systemctl restart nginx;;
            13) clear && systemctl status nginx;;
            14) clear && journalctl -n 100 -u nginx -f;;
            15) clear && systemctl stop nginx;;
            16) clear && service_create_interrupt_gpio ;;
            17) clear && systemctl restart $name"_"interrupt_gpio.service;;
            18) clear && systemctl status $name"_"interrupt_gpio.service;;
            19) clear && journalctl -n 100 -u $name"_"interrupt_gpio.service -f;;
            20) clear && systemctl stop $name"_"interrupt_gpio.service;;
            21) clear && service_create_interrupt_1w ;;
            22) clear && systemctl restart $name"_"interrupt_1w.service;;
            23) clear && systemctl status $name"_"interrupt_1w.service;;
            24) clear && journalctl -n 100 -u $name"_"interrupt_1w.service -f;;
            25) clear && systemctl stop $name"_"interrupt_1w.service;;
            26) clear && service_cron_min ;;
            27) clear && systemctl restart $name"_"service_cron_min.timer && systemctl restart $name"_"service_cron_min.service;;
            28) clear && systemctl status $name"_"service_cron_min.service;;
            29) clear && journalctl -n 100 -u $name"_"service_cron_min.service -f;;
            30) clear && systemctl stop $name"_"service_cron_min.timer && systemctl stop $name"_"service_cron_min.service;;
            31) clear && service_start_app_enable ;;
            32) clear && service_start_app_disable ;;
            33) clear && service_hotspod_enable ;;
            34) clear && service_hotspod_disable ;;
            35) clear && service_wifi_connect ;;
            q)  clear && menu_main;;
            *)  menu_main ;;
        esac
        echo -e "\n"
    done
}

#--------------------menu_cron : 3
menu_cron()
{
    clear
    while true; do
        getHeader
        echo -e  ${YELLOW}${LINE2}Cron        ${ENDCOLOR}
        echo -e  ${YELLOW}"1) ${GREEN}Daily"  ${ENDCOLOR}
        echo -e  ${YELLOW}"2) ${GREEN}Hourly" ${ENDCOLOR}
        echo -e  ${YELLOW}"3) ${GREEN}Minly"  ${ENDCOLOR}
        echo -e  ${YELLOW}"4) ${GREEN}Backup" ${ENDCOLOR}
        echo -e  ${YELLOW}${LINE2}            ${ENDCOLOR}
        read -p "Enter your choice [0-4]: " choice
        case $choice in            
            1) clear && cron_daily ;;
            2) clear && cron_hourly ;;
            3) clear && cron_minly ;;
            4) clear && cron_backup ;;
            q) clear && menu_main ;;
            *) menu_main ;;
        esac
        echo -e "\n"
    done
}

#--------------------menu_backup : 4
menu_backup()
{
    clear
    while true; do
        getHeader
        echo -e  ${YELLOW}${LINE2}Bckup${ENDCOLOR}
        echo -e  ${YELLOW}"1)  ${GREEN}Backup"      ${ENDCOLOR}
        echo -e  ${YELLOW}"2)  ${GREEN}Push github" ${ENDCOLOR}
        echo -e  ${YELLOW}"3)  ${GREEN}Restore"     ${ENDCOLOR}
        echo -e  ${YELLOW}${LINE2}                  ${ENDCOLOR}
        read -p "Enter your choice [1-3]: " choice
        case $choice in
            1) clear && backup_database ;;
            2) clear && github_push ;;
            3) clear && restore_database ;;
            *) menu_main ;;
        esac
        echo -e "\n"
    done
}

#---------------------------------------------------------------------------------api_interface
api_interface()
{
    if [  "$1" == "webapi_cron_min" ]; then webapi_cron_min; fi
    if [  "$1" == "install" ]; then all; fi
    if [  "$1" == "install_all" ]; then install_all; fi
    if [  "$1" == "install_gui" ]; then install_gui; fi
    if [  "$1" == "service_start_app_enable" ]; then service_start_app_enable; fi
    if [  "$1" == "service_hotspod_enable" ]; then service_hotspod_enable; fi
    if [  "$1" == "install_flutter" ]; then install_flutter; fi
    if [  "$1" == "service_startup" ]; then service_startup; fi
}

#---------------------------------------------------------------------------------Actions
source $api_sh
cd $path
if [  "$1" == "" ]; then menu_main; fi
if [  "$1" != "" ]; then api_interface $1 $2 $3 $4 $5; fi