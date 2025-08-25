<!--------------------------------------------------------------------------------- Description -->
# raspberrypi_iot_pubsub_python
    this is documents of raspberrypi_iot_pubsub_python

<!--------------------------------------------------------------------------------- Install -->
<br><br>

## Install

<!-------------------------- NATS -->
### NATS
```bash
cd /root
curl -fsSL https://binaries.nats.dev/nats-io/nats-server/v2@latest | sh
curl -fsSL https://binaries.nats.dev/nats-io/natscli/nats@latest | sh
sudo mv ./nats-server /usr/local/bin/
sudo mv ./nats /usr/local/bin/
sudo mv nats-server-v2.10.20-linux-amd64/nats-server.conf /etc/nats-server.conf
```

<!-------------------------- Python -->
### Python 
Source
```bash
git clone git@github.com:kashanimorteza/raspberrypi_iot_pubsub_python.git
cd raspberrypi_iot_pubsub_python
```
Python
```bash
add-apt-repository ppa:deadsnakes/ppa
apt update -y
apt install python3 -y
apt install python3-pip -y
apt install python3-venv -y
```
Virtual Environment
```bash
cd /root/raspberrypi_iot_pubsub_python
python3 -m venv .myenv3
.myenv3/bin/python3 -m pip install --upgrade pip  
source .myenv3/bin/activate
pip install -r requirements.txt  
```



<!--------------------------------------------------------------------------------- Tools -->
<br><br>

## Tools 
```bash
```

<!--------------------------------------------------------------------------------- Structure -->
<br><br>

## Structure 

<!--------------------------------------------------------------------------------- Note -->
<br><br>

## Note 