#!/bin/bash

#---------------------------------------------------------------------------------Tools
#-----------------------------getHeader : Shell
getHeader()
{
    echo -e "${RED}${LINE4}${name}"
}

#-----------------------------all
all()
{
    config_all
    install_all
    service_create_all
}


#---------------------------------------------------------------------------------Config
#-----------------------------config_all  : Shell
config_all()
{
    #----------Header
    echo -e "${YELLOW}${LINE2}config_all${ENDCOLOR}"
}



#---------------------------------------------------------------------------------Install
#-----------------------------install_all  : Shell
install_all()
{
    echo -e "${YELLOW}${LINE2}${LINE2}install_all${ENDCOLOR}"
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