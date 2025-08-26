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

    service_create_gpio_subscriber
}

#-----------------------------service_status
service_status_all()
{
    #----------Header
    echo -e "${YELLOW}service_status\n$LINE3${ENDCOLOR}"
    #----------Variable
    SERVICES=("${name}_gpio_subscriber.service")
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
    SERVICES=("${name}_gpio_subscriber.service")
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
    SERVICES=("${name}_gpio_subscriber.service")
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
    SERVICES=("${name}_gpio_subscriber.service")
    #----------Action
    for service in "${SERVICES[@]}"; do
        echo -e "${BLUE}$service${ENDCOLOR}"
        systemctl restart $service
    done
}

#-----------------------------service_create_gpio_subscriber
service_create_gpio_subscriber()
{
    echo -e "${YELLOW}service_create_gpio_subscriber\n$LINE3${ENDCOLOR}"

    #----------Variable
    service_name=gpio_subscriber

    #----------webapi
    echo -e "${BLUE}$name"_"${service_name}${ENDCOLOR}"
    echo """[Unit]
    Description=$name"_"${service_name}

    [Service]
    User=root
    WorkingDirectory=$path/
    ExecStart=python3 $path/subscriber/gpio.py
    SuccessExitStatus=143
    TimeoutStopSec=10
    Restart=on-failure
    RestartSec=65

    [Install]
    WantedBy=multi-user.target""" > /etc/systemd/system/${name}"_"${service_name}.service

    systemctl daemon-reload
    systemctl enable $name"_"${service_name}
    systemctl restart $name"_"${service_name}
}