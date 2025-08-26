#!/bin/bash

#---------------------------------------------------------------------------------Tools
#-----------------------------getHeader : Shell
getHeader()
{
    echo -e "${RED}${LINE4}${name} ${getMode_value}"
}

#-----------------------------log  : Shell
log()
{
    datetime=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "\n${datetime} | ${log_variable}" >> $log_folder/sys.log
}

#-----------------------------check_os  : Shell
check_os() 
{
    if [[ "$OSTYPE" == "darwin"* ]]; then
        check_os_value="mac"
    elif [[ -f /etc/lsb-release ]]; then
        if grep -qi 'ubuntu' /etc/lsb-release; then check_os_value="ubuntu"; else check_os_value="other"; fi
    else
         check_os_value="other"
    fi
    echo $check_os_value
}

#-----------------------------create_folder  : Shell
create_folder()
{
    echo -e "${YELLOW}${LINE2}Create folder${ENDCOLOR}"

    #---Remove backup
    echo -e "rm -fr $backup_folder"
    rm -fr $backup_folder
    #---Create backup
    echo -e "mkdir -p $backup_folder"
    mkdir -p $backup_folder

    #---Create config
    echo -e "mkdir -p $backup_folder/config"
    mkdir -p $backup_folder/config
    #---Create xray
    echo -e "mkdir -p $backup_folder/xray"
    mkdir -p $backup_folder/xray
    #---Create database
    echo -e "mkdir -p $backup_folder/database"
    mkdir -p $backup_folder/database
    #---Create cert
    echo -e "mkdir -p $backup_folder/cert"
    mkdir -p $backup_folder/cert
    
    #---Create server
    echo -e "mkdir -p $backup_folder/server"
    mkdir -p $backup_folder/server
    #---Copy backup to server
    echo -e "rsync -av --exclude='server' $backup_folder $backup_folder/server"
    rsync -av --exclude='server' $backup_folder/* $backup_folder/server

    #---Permission
    echo -e ${BLUE}"Permission"${ENDCOLOR}
    echo -e "chmod 777 $backup_folder/*"
    chmod 777 $backup_folder/*

    #---Create Log
    file=$log_folder
    echo -e "Log : sudo mkdir -p $file"
    mkdir -p $file
    touch $file/daily.log
    touch $file/hourly.log
    touch $file/minly.log
    touch $file/error.log
    touch $file/sys.log
    touch $file/telegram.log
    touch $file/user.log
    touch $file/link.log
    chmod 777 $log_folder/*
}

#-----------------------------monitor  : Shell
monitor()
{
    echo -e "${YELLOW}${LINE2}monitor${ENDCOLOR}"

    wifiip=$(ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

    echo -e "${BLUE}Webapi${ENDCOLOR}"
    echo -e "${ENDCOLOR}http://${webapi_host}:${webapi_port}${ENDCOLOR}"
    echo -e "${ENDCOLOR}http://${webapi_host}:${webapi_port}/doc1${ENDCOLOR}"

    echo -e "${BLUE}Nginx API${ENDCOLOR}"
    echo -e "${ENDCOLOR}http://${wifiip}:${nginx_api_port}/${nginx_api_key}/doc1${ENDCOLOR}"

    echo -e "${BLUE}Nginx GUI${ENDCOLOR}"
    echo -e "${ENDCOLOR}http://${wifiip}:${nginx_gui_port}/${nginx_gui_key}${ENDCOLOR}"
}

#-----------------------------all
all()
{
    config_all
    install_all
    service_create_all
}

#-----------------------------webapi_cron_min : API
webapi_cron_min()
{
    echo -e "${YELLOW}webapi_cron_min\n$LINE3${ENDCOLOR}"
    echo -e "http://$webapi_host:$webapi_port/admin/cron_min"
    result=$(curl -sSX 'GET' "http://$webapi_host:$webapi_port/admin/cron_min" -H 'accept: application/json')
    echo "$result" | jq '.'
}



#---------------------------------------------------------------------------------Config
#-----------------------------config_all  : Shell
config_all()
{
    #----------Header
    echo -e "${YELLOW}${LINE2}config_all${ENDCOLOR}"

    config_general
    config_network
    
}

#-----------------------------config_general  : Shell
config_general()
{
    echo -e "${YELLOW}${LINE2}config_general${ENDCOLOR}"

    # echo -e "${BLUE}Bashrc${ENDCOLOR}"
    # echo "cd $path && source .myenv3/bin/activate && ./cli.sh" >> /root/.bashrc

    echo -e "${BLUE}sudo timedatectl set-timezone $timeZone${ENDCOLOR}"
    sudo timedatectl set-timezone $timeZone

    echo -e "${BLUE}sudo echo $name > /etc/hostname${ENDCOLOR}"
    sudo echo $name > /etc/hostname
}

#-----------------------------config_network  : Shell
config_network()
{
    echo -e "${YELLOW}${LINE2}config_network${ENDCOLOR}"

    #---IPV4
    sudo sysctl -w net.ipv4.ip_forward=1
    sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf    
}

#-----------------------------config_git  : Shell
config_git()
{
    echo -e "${YELLOW}${LINE2}config_git${ENDCOLOR}"

    echo -e "${BLUE}${git_name}${ENDCOLOR}"
    echo -e "${BLUE}${git_email}${ENDCOLOR}"

    git config --global user.email "${git_email}"
    git config --global user.name "${git_name}"
    git config --global core.editor "vim"
    git config user.email "${git_email}"
    git config user.name "${git_name}"
    git config core.editor "vim"
    git config pull.rebase false
}



#---------------------------------------------------------------------------------Install
#-----------------------------install_all  : Shell
install_all()
{
    echo -e "${YELLOW}${LINE2}${LINE2}install_all${ENDCOLOR}"
        
    install_update
    #install_upgrade
    install_general
    install_python
    install_nginx
    install_iptables
}

#-----------------------------install_update  : Shell
install_update()
{
    echo -e "${YELLOW}${LINE2}install_update${ENDCOLOR}"

    echo -e "${BLUE}sudo apt update ${ENDCOLOR}"
    apt update -y
    echo -e "${BLUE}sudo dpkg --configure -a${ENDCOLOR}"
    sudo dpkg --configure -a
}

#-----------------------------install_upgrade  : Shell
install_upgrade()
{
    echo -e "${YELLOW}${LINE2}install_upgrade${ENDCOLOR}"

    echo -e "${BLUE}sudo apt upgrade ${ENDCOLOR}"
    sudo apt upgrade -y

    echo -e "${BLUE}apt-clone${ENDCOLOR}"
    dpkg --get-selections > package-list.txt
    sudo dpkg --set-selections < package-list.txt
    sudo apt-get update
    sudo apt-get dselect-upgrade

}

#-----------------------------install_general  : Shell
install_general()
{
    echo -e "${YELLOW}${LINE2}install_general${ENDCOLOR}"

    echo -e "${BLUE}apt install -yqq --no-install-recommends ca-certificates${ENDCOLOR}"
    sudo apt install -yqq --no-install-recommends ca-certificates

    echo -e "${BLUE}apt install curl git telnet sqlite3 jq vim hostapd dnsmasq dhcpcd5 unclutter${ENDCOLOR}"
    sudo apt install curl git telnet sqlite3 jq vim hostapd dnsmasq dhcpcd5 unclutter -y
}

#-----------------------------install_python  : Shell
install_python()
{
    echo -e "${YELLOW}${LINE2}install_python${ENDCOLOR}"

    add-apt-repository ppa:deadsnakes/ppa -y
    apt install python3 -y  
    apt install python3-pip -y  
    apt install python3-venv -y  
}

#-----------------------------install_gui  : Shell
install_gui()
{
    echo -e "${YELLOW}${LINE2}install_gui${ENDCOLOR}"

    sudo apt install mesa-utils xserver-xorg xinit x11-utils lightdm lightdm-gtk-greeter openbox -y
    sudo systemctl set-default graphical.target
    sudo systemctl enable lightdm
    sudo dpkg-reconfigure lightdm
}

#-----------------------------install_flutter  : Shell
install_flutter()
{
    echo -e "${YELLOW}${LINE2}install_flutter${ENDCOLOR}"

    sudo apt install clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev unclutter -y
}

#-----------------------------install_nginx  : Shell
install_nginx()
{
    echo -e "${YELLOW}${LINE2}install_nginx${ENDCOLOR}"

    sudo apt install nginx -y
    rm -fr /etc/nginx/sites-enabled/default
    systemctl restart nginx
}

#-----------------------------install_postgres  : Shell
install_postgres()
{
    echo -e "${YELLOW}${LINE2}install_postgres${ENDCOLOR}"

    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    apt update
    apt -y install postgresql
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '127.0.0.1'/" /etc/postgresql/17/main/postgresql.conf
    echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/17/main/pg_hba.conf
    systemctl enable postgresql
    systemctl start postgresql
    systemctl restart postgresql
}

#-----------------------------install_iptables  : Shell
install_iptables()
{
    echo -e "${YELLOW}${LINE2}Install iptables | Unistall UFW | Configure iptables${ENDCOLOR}"

    #---unistall ufw
    echo -e "${BLUE}unistall ufw${ENDCOLOR}"
    apt remove ufw -y
    apt purge ufw  -y
    #---install iptables
    echo -e "${BLUE}install iptables${ENDCOLOR}"
    sudo apt install iptables iptables-persistent -y
    #---configure iptables
    echo -e "${BLUE}configure iptables${ENDCOLOR}"
    sudo iptables -F 
    sudo iptables -X
    sudo iptables -P OUTPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
    sudo iptables -P INPUT ACCEPT    
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A OUTPUT -o lo -j ACCEPT
    sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A INPUT -p icmp -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 11011 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 22022 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 33033 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 44044 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1090 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1091 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1092 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1093 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1094 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1095 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1096 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1097 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1098 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1099 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1100 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1101 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 1102 -j ACCEPT
    #---save iptables config
    echo -e "${BLUE}save iptables config${ENDCOLOR}"
    sudo iptables-save | uniq > /etc/iptables/rules.v4
    #---restart iptables
    systemctl restart iptables
    #---crontab
    if ! crontab -l | grep -q "@reboot systemctl restart iptables"; then (crontab -l; echo "@reboot systemctl restart iptables") | crontab -; fi
    #---Log
    log_variable="api.sh | install_iptables"; log
}



#---------------------------------------------------------------------------------Service
#-----------------------------service_create_all
service_create_all()
{
    #----------Header
    echo -e "${YELLOW}service_create_all\n$LINE3${ENDCOLOR}"

    service_create_webapi
    service_create_nginx_create_api
    service_create_nginx_create_gui
    service_create_interrupt_gpio
    service_create_interrupt_1w
    service_cron_min
}

#-----------------------------service_status
service_status_all()
{
    #----------Header
    echo -e "${YELLOW}service_status\n$LINE3${ENDCOLOR}"
    #----------Variable
    SERVICES=("iptables" "nginx" "${name}_webapi.service" "${name}_interrupt_gpio.service" "${name}_interrupt_1w.service" "${name}_cron_min.timer")
    #----------Action
    for service in "${SERVICES[@]}"; do
        if systemctl is-active --quiet "$service"; then
            echo -e "$service : ${GREEN}on${ENDCOLOR}"
        else
            echo -e "$service : ${RED}off${ENDCOLOR}"
        fi
    done
}

#-----------------------------service_remove_all
service_remove_all()
{
    #----------Header
    echo -e "${YELLOW}service_remove_all\n$LINE3${ENDCOLOR}"
    #----------Variable
    SERVICES=("iptables" "nginx" "${name}_webapi.service" "${name}_interrupt_gpio.service" "${name}_interrupt_1w.service" "${name}_cron_min.timer")
    #----------Action
    for service in "${SERVICES[@]}"; do
        echo -e "${BLUE}$service${ENDCOLOR}"
        systemctl stop $service
        rm -fr /etc/systemd/system/$service
    done
    systemctl daemon-reload
}

#-----------------------------service_stop_all
service_stop_all()
{
    #----------Header
    echo -e "${YELLOW}service_stop_all\n$LINE3${ENDCOLOR}"
    #----------Variable
    SERVICES=("iptables" "nginx" "${name}_webapi.service" "${name}_interrupt_gpio.service" "${name}_interrupt_1w.service" "${name}_cron_min.timer")
    #----------Action
    for service in "${SERVICES[@]}"; do
        echo -e "${BLUE}$service${ENDCOLOR}"
        systemctl stop $service
    done
}

#-----------------------------service_restart_all
service_restart_all()
{
    #----------Header
    echo -e "${YELLOW}service_stop_all\n$LINE3${ENDCOLOR}"
    #----------Variable
    SERVICES=("iptables" "nginx" "${name}_webapi.service" "${name}_interrupt_gpio.service" "${name}_interrupt_1w.service" "${name}_cron_min.timer")
    #----------Action
    for service in "${SERVICES[@]}"; do
        echo -e "${BLUE}$service${ENDCOLOR}"
        systemctl restart $service
    done
}

#-----------------------------service_wifi_connect
service_wifi_connect()
{
    #----------Header
    echo -e "${YELLOW}service_wifi_connect\n$LINE3${ENDCOLOR}"
    
    #----------Action
    echo -e "${BLUE}nmcli device wifi list${ENDCOLOR}"
    echo -e "${BLUE}nmcli device wifi connect $wifi_ssid password $wifi_pass ifname wlan0${ENDCOLOR}"
    echo -e "${BLUE}nmcli connection modify $wifi_ssid connection.autoconnect yes ipv4.method manual ipv4.addresses $wifi_ip/24${ENDCOLOR}"

    sudo nmcli device wifi list
    sudo nmcli device wifi connect "$wifi_ssid" password "$wifi_pass" ifname wlan0
    sudo nmcli connection modify "$wifi_ssid" connection.autoconnect yes ipv4.method manual ipv4.addresses $wifi_ip/24 ipv4.gateway 192.168.1.1 ipv4.dns "8.8.8.8"
}

#-----------------------------service_start_app_enable
service_start_app_enable()
{
    #----------Header
    echo -e "${YELLOW}service_start_app_enable\n$LINE3${ENDCOLOR}"
    #----------Action
    sudo echo "[Seat:*]
autologin-user=rasp
autologin-user-timeout=0
user-session=openbox" >> /etc/lightdm/lightdm.conf
    mkdir -p /home/rasp/.config/openbox
    sudo echo "unclutter -idle 0 & /home/rasp/desktop-app/mkpanel_gui & exec openbox-session" > /home/rasp/.config/openbox/autostart
    chmod +x /home/rasp/.config/openbox/autostart
}

#-----------------------------service_start_app_disable
service_start_app_disable()
{
    #----------Header
    echo -e "${YELLOW}service_start_app_disable\n$LINE3${ENDCOLOR}"
    #----------Action
    rm -fr /home/rasp/.config/openbox
}

#-----------------------------service_hotspod_enable
service_hotspod_enable()
{
    #----------Header
    echo -e "${YELLOW}service_hotspod_enable\n$LINE3${ENDCOLOR}"

    #----------Monitor
    echo -e "${YELLOW}hotspod_ip : $hotspod_ip\n$LINE3${ENDCOLOR}"
    echo -e "${YELLOW}hotspod_pass : $hotspod_pass\n$LINE3${ENDCOLOR}"
    echo -e "${YELLOW}hotspod_ip : $hotspod_ip\n$LINE3${ENDCOLOR}"
    echo -e "${YELLOW}hotspod_ip : $hotspod_ip\n$LINE3${ENDCOLOR}"

    #----------Action
    echo -e "${YELLOW}systemctl stop hostapd\n$LINE3${ENDCOLOR}"
    echo -e "${YELLOW}systemctl stop dnsmasq\n$LINE3${ENDCOLOR}"
    sudo systemctl stop hostapd
    sudo systemctl stop dnsmasq

    echo -e "${YELLOW}echo to /etc/dhcpcd.conf\n$LINE3${ENDCOLOR}"
    sudo echo "interface wlan0
static ip_address=$hotspod_ip/24
nohook wpa_supplicant" > /etc/dhcpcd.conf

    echo -e "${YELLOW}systemctl restart dhcpcd\n$LINE3${ENDCOLOR}"
    sudo systemctl restart dhcpcd

    echo -e "${YELLOW}/etc/dnsmasq.conf\n$LINE3${ENDCOLOR}"
    sudo echo "interface=wlan0
dhcp-range=192.168.1.2,192.168.1.20,255.255.255.0,24h" > /etc/dnsmasq.conf

    echo -e "${YELLOW}/etc/hostapd/hostapd.conf\n$LINE3${ENDCOLOR}"
    sudo echo "interface=wlan0
driver=nl80211
ssid=$hotspod_ssid
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$hotspod_pass
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" > /etc/hostapd/hostapd.conf

    echo -e "${YELLOW}/etc/default/hostapd\n$LINE3${ENDCOLOR}"
    sudo echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' > /etc/default/hostapd

    echo -e "${YELLOW}sudo systemctl unmask hostapd\n$LINE3${ENDCOLOR}"
    sudo systemctl unmask hostapd
    echo -e "${YELLOW}sudo systemctl enable hostapd\n$LINE3${ENDCOLOR}"
    sudo systemctl enable hostapd
    echo -e "${YELLOW}systemctl enable dnsmasq\n$LINE3${ENDCOLOR}"
    sudo systemctl enable dnsmasq
    
    echo -e "${YELLOW}sudo systemctl start hostapd\n$LINE3${ENDCOLOR}"
    sudo systemctl start hostapd
    echo -e "${YELLOW}sudo systemctl start dnsmasq\n$LINE3${ENDCOLOR}"
    sudo systemctl start dnsmasq
    
    echo -e "${YELLOW}/etc/network/interfaces\n$LINE3${ENDCOLOR}"
    sudo echo "auto wlan0
iface wlan0 inet static
address $hotspod_ip
netmask 255.255.255.0" > /etc/network/interfaces

    sudo reboot
}

#-----------------------------service_hotspod_disable
service_hotspod_disable()
{
    #----------Header
    echo -e "${YELLOW}service_hotspod_disable\n$LINE3${ENDCOLOR}"
    #----------Action
    rm -fr /etc/dhcpcd.conf
    rm -fr /etc/dnsmasq.conf
    rm -fr /etc/hostapd/hostapd.conf
    rm -fr /etc/default/hostapd
    rm -fr /etc/network/interfaces
    #----------Service
    sudo systemctl stop hostapd
    sudo systemctl disable hostapd
    sudo systemctl mask hostapd
    sudo systemctl unmask hostapd
    sudo killall hostapd
    sudo systemctl stop dnsmasq
    sudo systemctl disable dnsmasq

    sudo reboot
}

#-----------------------------service_startup
service_startup()
{
    #----------Header
    echo -e "${YELLOW}service_startup\n$LINE3${ENDCOLOR}"

    #----------action
    echo $path/startup.sh >> /root/.bashrc
}

#-----------------------------service_create_webapi
service_create_webapi()
{
    echo -e "${YELLOW}service_create_webapi\n$LINE3${ENDCOLOR}"

    #----------Variable
    api_host=$webapi_host
    api_port=$webapi_port
    api_workers=$webapi_workers

    #----------webapi
    echo -e "${BLUE}$name"_"webapi${ENDCOLOR}"
    echo """[Unit]
    Description=$name"_"webapi

    [Service]
    User=root
    WorkingDirectory=$path/
    ExecStart=$path/.myenv3/bin/uvicorn api:app --host $api_host --port $api_port --workers $api_workers
    SuccessExitStatus=143
    TimeoutStopSec=10
    Restart=on-failure
    RestartSec=65

    [Install]
    WantedBy=multi-user.target""" > /etc/systemd/system/$name"_"webapi.service

    systemctl daemon-reload
    systemctl enable $name"_"webapi
    systemctl restart $name"_"webapi
}

#-----------------------------service_create_nginx_create_api
service_create_nginx_create_api()
{
    #----------Header
    echo -e "${YELLOW}nginx_create_api\n$LINE3${ENDCOLOR}"
    #----------Variable
    host=$nginx_api_host
    port=$nginx_api_port
    key=$nginx_api_key
    api_host=$webapi_host
    api_port=$webapi_port
    #----------Action
    echo "server {
    listen $port;
    server_name _;

        location /$key {
            proxy_pass http://$api_host:$api_port;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;

            proxy_ssl_verify off;

            proxy_connect_timeout 60s;
            proxy_send_timeout 60s;
            proxy_read_timeout 60s;
            send_timeout 60s;
        }
    }" > /etc/nginx/sites-available/$name"_"api.conf
    ln -s /etc/nginx/sites-available/$name"_"api.conf /etc/nginx/sites-enabled/
    nginx -t
    systemctl reload nginx
    systemctl restart nginx
}

#-----------------------------service_create_nginx_create_gui
service_create_nginx_create_gui()
{
    #----------Header
    echo -e "${YELLOW}nginx_create_gui\n$LINE3${ENDCOLOR}"
    #----------Variable
    host=$nginx_gui_host
    port=$nginx_gui_port
    key=$nginx_gui_key
    #----------Files
    echo -e "rm -fr /var/www/$name"_"gui"
    rm -fr /var/www/$name"_"gui
    echo -e "mkdir -p /var/www/$name"_"gui/"
    mkdir -p /var/www/$name"_"gui/
    echo -e "chown -R $USER:$USER /var/www/$name"_"gui/"
    chown -R $USER:$USER /var/www/$name"_"gui/
    echo -e "chmod -R 755 /var/www/$name"_"gui/"
    chmod -R 755 /var/www/$name"_"gui/
    echo -e "cp -fr $path_gui/* /var/www/$name"_"gui/"
    cp -fr $path_gui/* /var/www/$name"_"gui/
    #----------Action
    echo "server {
    listen $port;
    server_name _;
        location /$key {
            alias /var/www/$name"_"gui;
            index index.html;
            try_files \$uri \$uri/ =404;
        }
    }" > /etc/nginx/sites-available/$name"_"gui.conf
    ln -s /etc/nginx/sites-available/$name"_"gui.conf /etc/nginx/sites-enabled/
    nginx -t
    systemctl reload nginx
    systemctl restart nginx
}

#-----------------------------service_create_interrupt_gpio
service_create_interrupt_gpio()
{
    echo -e "${YELLOW}service_create_interrupt_gpio\n$LINE3${ENDCOLOR}"

    #----------Variable
    service_name="interrupt_gpio"

    #----------webapi
    echo -e "${BLUE}$name"_"$service_name${ENDCOLOR}"
    echo """[Unit]
    Description=$name"_"$service_name

    [Service]
    User=root
    WorkingDirectory=$path/
    ExecStart=python3 $path/$service_name.py
    SuccessExitStatus=143
    TimeoutStopSec=10
    Restart=on-failure
    RestartSec=65

    [Install]
    WantedBy=multi-user.target""" > /etc/systemd/system/$name"_"$service_name.service

    systemctl daemon-reload
    systemctl enable $name"_"$service_name
    systemctl restart $name"_"$service_name
}

#-----------------------------service_create_interrupt_1w
service_create_interrupt_1w()
{
    echo -e "${YELLOW}service_create_interrupt_1w\n$LINE3${ENDCOLOR}"

    #----------Variable
    service_name="interrupt_1w"

    #----------webapi
    echo -e "${BLUE}$name"_"$service_name${ENDCOLOR}"
    echo """[Unit]
    Description=$name"_"$service_name

    [Service]
    User=root
    WorkingDirectory=$path/
    ExecStart=python3 $path/$service_name.py
    SuccessExitStatus=143
    TimeoutStopSec=10
    Restart=on-failure
    RestartSec=65

    [Install]
    WantedBy=multi-user.target""" > /etc/systemd/system/$name"_"$service_name.service

    systemctl daemon-reload
    systemctl enable $name"_"$service_name
    systemctl restart $name"_"$service_name
}

#-----------------------------service_cron_min
service_cron_min()
{
    echo -e "${YELLOW}service_cron_min\n$LINE3${ENDCOLOR}"

    #----------Variable
    service_name="cron_min"

    #----------Service
    echo -e "${BLUE}$name"_"$service_name${ENDCOLOR}"

    #----------Service
    echo """[Unit]
    Description=$name"_"$service_name"_"service

    [Service]
    User=root
    WorkingDirectory=$path/
    ExecStart=$path/cli.sh webapi_cron_min
    SuccessExitStatus=143
    TimeoutStopSec=10
    Restart=on-failure
    RestartSec=65

    [Install]
    WantedBy=multi-user.target""" > /etc/systemd/system/$name"_"$service_name.service

    #----------timer
    echo "[Unit]
    Description=$name"_"$service_name"_"timer

    [Timer]
    OnBootSec=0min
    OnUnitActiveSec=1min
    Unit=$name"_"$service_name.service

    [Install]
    WantedBy=multi-user.target""" > /etc/systemd/system/$name"_"$service_name.timer

    #----------Restart
    systemctl daemon-reload
    systemctl enable $name"_"$service_name.timer
    systemctl restart $name"_"$service_name.timer
}

#-----------------------------nginx_remove_gui
nginx_remove_gui()
{
    #----------Header
    echo -e "${YELLOW}nginx_remove_gui\n$LINE3${ENDCOLOR}"
    #----------Action
    echo -e "rm -fr /etc/nginx/sites-available/$name"_"gui.conf"
    rm -fr /etc/nginx/sites-available/$name"_"gui.conf
    echo -e "rm -fr /etc/nginx/sites-enabled/$name"_"gui.conf"
    rm -fr /etc/nginx/sites-enabled/$name"_"gui.conf
    systemctl reload nginx
    systemctl restart nginx
}



#---------------------------------------------------------------------------------Backup
#-----------------------------backup_sqlite
backup_sqlite()
{
    NOW=$(date +"%Y-%m-%d-%H-%M-%S")
    echo -e "${YELLOW}${LINE2}Backup database${ENDCOLOR}"
    echo -e "${BLUE}cp -fr $path/database.db $path/database/sqlite_$NOW${ENDCOLOR}"
    mkdir -p $path/database
    cp -fr $path/database.db $path/database/sqlite_$NOW
}

#-----------------------------github_push
github_push()
{
    NOW=$(date +"%Y-%m-%d %H:%M:%S")
    echo -e "${YELLOW}${LINE2}github_push${ENDCOLOR}"
    echo -e "cd $path && git add . && git commit -m "$NOW" && git push"
    cd $path && git add . && git commit -m "$NOW" && git push
}
#-----------------------------github_pull
github_pull()
{
    echo -e "${YELLOW}${LINE2}github_pull${ENDCOLOR}"

    echo -e "${BLUE}cd $path && git pull${ENDCOLOR}"
    cd $path && git pull
}