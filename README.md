<!--------------------------------------------------------------------------------- Description -->
# raspberrypi_iot_pubsub_python
    this is documents of raspberrypi_iot_pubsub_python

<!--------------------------------------------------------------------------------- Install -->
<br><br>

## Install

<!-------------------------- OS -->
OS
```
Download Raspberry Pi Imager
Download Raspberry Pi OS Lite
Install OS On MMC Memory With custom configuration
user : rasp 123456
Wifi : Mori-Android Morteza1001110
```
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
```bash
ssh root@10.209.244.237
```
```bash
apt update
apt upgrade
sudo apt install -y jq yq git vim
```
<!-------------------------- Git -->
Git
```bash
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
sudo chown -R root:root /root/.ssh
sudo chmod 700 /root/.ssh
sudo chmod 644 /root/.ssh/github-morteza.pub
sudo chmod 600 /root/.ssh/github-morteza.key
sudo chmod 600 /root/.ssh/config
```
<!-------------------------- NATS -->
NATS
```bash
curl -fsSL https://binaries.nats.dev/nats-io/nats-server/v2@latest | sh
curl -fsSL https://binaries.nats.dev/nats-io/natscli/nats@latest | sh
sudo mv ./nats-server /usr/local/bin/
sudo mv ./nats /usr/local/bin/
sudo mv nats-server-v2.10.20-linux-amd64/nats-server.conf /etc/nats-server.conf
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
```bash
pip install PyYAML --break-system-packages
pip install nats-py --break-system-packages
```

<!--------------------------------------------------------------------------------- Source -->
<br><br>

## Source 
Download
```bash
git clone git@github.com:kashanimorteza/raspberrypi_iot_pubsub_python.git
cd raspberrypi_iot_pubsub_python
```
Virtual Environment
```bash
python3 -m venv .myenv3
.myenv3/bin/python3 -m pip install --upgrade pip  
source .myenv3/bin/activate
pip install -r requirements.txt  
```

<!--------------------------------------------------------------------------------- Example -->
<br><br>

## Example
Write value to GPIO port
```bash
nats pub d1.gpio.write.gpio-11.1 ""
```
Read value from GPIO port
```bash
nats req d1.gpio.read.gpio-11
```
Read value from GPIO interrupt
```bash
nats sub 'interrupt.>'
```

<!--------------------------------------------------------------------------------- Tools -->
<br><br>

## Tools 
<!-------------------------- Git -->
Git
```bash
git fetch origin
git reset --hard origin/main
```
<!-------------------------- Network -->
Network
```bash
iwconfig
nmcli device wifi list
nmtui
nmcli device wifi connect "Mori-Android" password "Morteza1001110" ifname wlan0
nmcli connection modify "Mori-Android" connection.autoconnect yes
```
DNS
```bash
echo "" > /etc/resolv.conf
echo "nameserver 185.51.200.2" > /etc/resolv.conf
echo "nameserver 178.22.122.100" >> /etc/resolv.conf
```