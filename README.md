# raspberrypi_iot_pubsub_python
    this is raspberrypi_iot_pubsub_python


<!--------------------------------------------------------------------------------- OS -->
<br><br>

## OS
<!-------------------------- Install -->
Install

    Download Raspberry Pi Imager 1.8.5
    Download Raspberry Pi OS Lite (64-bit)
    Install OS On MMC Memory With custom configuration
    user : rasp 123456
    Wifi : Mori-Android Morteza1001110
<!-------------------------- Configure -->
Configure
```bash
ssh rasp@10.209.244.237
```
```bash
sudo su -
echo "root:123456" | sudo chpasswd
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh
systemctl restart sshd
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCvYjhRa8pdECIlwQQM8BdxY9zd7+fmA2kLBgppAf8phOR/GZ8AfpzxCduk2iKFktjVQteIKuczXefN4DPeM76M1HG8eZ9BoDiQwIzT/nNuLu19FsY8PexJznhXT3uOwORpoVNrEy6nKsESvUQYlebtiS9ZkmTO2gSjADC3wwSWbw== root@laptop" > /root/.ssh/authorized_keys
```
<!-------------------------- Git -->
Git
```bash
sudo apt install git
sudo git config --global user.email "kashani.morteza@gmail.com"
sudo git config --global user.name "morteza"
sudo git config --global core.editor vim
sudo git config pull.rebase false
```
```bash
rsync -avz /Users/morteza/.ssh/config root@10.209.244.237:/root/.ssh/
rsync -avz /Users/morteza/.ssh/github-morteza.pub root@10.209.244.237:/root/.ssh/
rsync -avz /Users/morteza/.ssh/github-morteza.key root@10.209.244.237:/root/.ssh/
```
```bash
ssh root@10.209.244.237
```
```bash
sudo chown -R root:root /root/.ssh
sudo chmod 700 /root/.ssh
sudo chmod 644 /root/.ssh/github-morteza.pub
sudo chmod 600 /root/.ssh/github-morteza.key
sudo chmod 600 /root/.ssh/config
```

<!--------------------------------------------------------------------------------- Source  -->
<br><br>

## Source 
<!-------------------------- Download -->
Download
```bash
git clone git@github.com:kashanimorteza/raspberrypi_iot_core_python.git
cd raspberrypi_iot_core_python
```
<!-------------------------- Python -->
Python
```bash
add-apt-repository ppa:deadsnakes/ppa
apt update -y
apt install python3 -y
apt install python3-pip -y
apt install python3-venv -y
```
<!-------------------------- Virtual Environment -->
#### Virtual Environment
```bash
cd /root/raspberrypi_iot_core_python
python3 -m venv .myenv3
.myenv3/bin/python3 -m pip install --upgrade pip  
source .myenv3/bin/activate  
pip install -r requirements.txt  
```
<!-------------------------- Database -->
Database 
```bash
cd /root/raspberrypi_iot_core_python
source .myenv3/bin/activate
python3 ./database_fill.py
```
<!-------------------------- Install requirements -->
Install requirements
```bash
/root/raspberrypi_iot_core_python/cli.sh install
# /root/raspberrypi_iot_core_python/cli.sh install_gui
# /root/raspberrypi_iot_core_python/cli.sh service_start_app_enable
# /root/raspberrypi_iot_core_python/cli.sh service_hotspod_enable
```

<!--------------------------------------------------------------------------------- Hardware  -->
<br><br>

## Hardware
Enable 1-Wire
```bash
raspi-config
Interface Options
1-Wire → Enable
Serial Port → Enable
reboot

vim /boot/firmware/config.txt:
dtoverlay=w1-gpio,gpiopin=4
```
Devices
```bash
cd /sys/bus/w1/devices && ls
ls /sys/bus/w1/devices
```


<!--------------------------------------------------------------------------------- Tools  -->
<br><br>

## Tools

#### Postgresql
<!------------------------- Install -->
Install
```bash
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt update
apt -y install postgresql
```
<!------------------------- Config -->
Config
```bash
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '0.0.0.0'/" /etc/postgresql/17/main/postgresql.conf
sed -i "s/max_connections = 100/max_connections = 200/" /etc/postgresql/17/main/postgresql.conf
echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/17/main/pg_hba.conf
```
<!------------------------- Service -->
Service
```bash
sudo systemctl restart postgresql
sudo systemctl status postgresql
```
<!------------------------- Role -->
Database
```bash
psql -U postgres -d postgres
ALTER USER raspberrypi WITH PASSWORD '123456';
```


#### DNS
```bash
echo "" > /etc/resolv.conf
echo "nameserver 185.51.200.2" > /etc/resolv.conf
echo "nameserver 178.22.122.100" >> /etc/resolv.conf
```
#### Backup apt
```bash
tar czvf /root/apt-backup.tar.gz /var/cache/apt/archives
rsync -avz root@10.209.244.237:/root/apt-backup.tar.gz /Volumes/data/develop/raspberrypi/
```
#### Restore apt
```bash
rsync -avz /Volumes/data/develop/raspberrypi/apt-backup.tar.gz root@10.209.244.237:/root/ 
mkdir -p /root/apt-backup
tar xzvf /root/apt-backup.tar.gz -C /root/apt-backup
cp -fr ./apt-backup/var/* /var/
rm -fr apt-backup
rm -fr apt-backup apt-backup.tar.gz
```
#### Backup python
```bash
tar czvf /root/python-env.tar.gz /root/raspberrypi_iot_core_python/.myenv3
rsync -avz root@10.209.244.237:/root/python-env.tar.gz /Volumes/data/develop/raspberrypi/
```
#### Python ENV
```bash
cd /root/raspberrypi_iot_core_python
python3 -m venv .myenv3
.myenv3/bin/python3 -m pip install --upgrade pip  
source .myenv3/bin/activate  
pip install -r requirements.txt  
```
#### SSH config
```bash
#----------------------------[Raspberrypi]
Host 10.209.244.237 192.168.1.110 10.209.244.237
user=root
PreferredAuthentications publickey
IdentityFile ~/.ssh/server_local.key
```
#### Startup
```bash
echo "/root/raspberrypi_iot_core_python/startup.sh" >> /root/.bashrc
```
#### Network
```bash
nmtui
iwconfig
nmcli device wifi list
nmcli device wifi connect "Mori" password "Morteza1001" ifname wlan0
nmcli device wifi connect "Mori-Android" password "Morteza1001" ifname wlan0
nmcli device wifi connect "Mori-Android" password "Morteza1001" ifname wlan0

nmcli connection modify "Mori-Android" connection.autoconnect yes

nmcli device wifi connect "MK-5" password "Abd1001110aaaabbbb" ifname wlan0
```
#### Git
```bash
git fetch origin
git reset --hard origin/main
```
#### Kernel silent
```bash
vim /boot/firmware/cmdline.txt
quiet loglevel=0 splash vt.global_cursor_default=0
```

<!--------------------------------------------------------------------------------- Task  -->
<br><br>

## Task
    Create image of memory
    Encrypt source
    SSl
    Authentication
    Server
    GSM module

<!--------------------------------------------------------------------------------- Transfer Source to raspberripi  -->
<br><br>

## Transfer Source to raspberripi
```bash
rsync -avz /Volumes/data/projects/raspberrypi_iot_core_python/* root@10.209.244.237:/root/raspberrypi_iot_core_python/
```
#### Virtual Environment
```bash
rsync -avz /Volumes/data/develop/raspberrypi/python-env.tar.gz root@10.209.244.237:/root/
mkdir -p /root/python-env
tar xzvf /root/python-env.tar.gz -C /root/python-env 
cp -fr /root/python-env/root/raspberrypi_iot_core_python/.myenv3 /root/raspberrypi_iot_core_python
rm -fr /root/python-env /root/python-env.tar.gz
```
#### Install requirements
```bash
/root/raspberrypi_iot_core_python/cli.sh install_all
/root/raspberrypi_iot_core_python/cli.sh install_gui
/root/raspberrypi_iot_core_python/cli.sh service_start_app_enable
/root/raspberrypi_iot_core_python/cli.sh service_hotspod_enable
```
#### Database 
```bash
cd /root/raspberrypi_iot_core_python
source .myenv3/bin/activate
python3 ./database_fill.py
```
#### Cli
```bash
/root/raspberrypi_iot_core_python/cli.sh install
```