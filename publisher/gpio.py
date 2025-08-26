#--------------------------------------------------------------------------------- Location
# publisher/gpio.py

#--------------------------------------------------------------------------------- Description
# publisher gpio

#--------------------------------------------------------------------------------- Import
import os, sys, asyncio
import RPi.GPIO as GPIO
from nats.aio.client import Client as NATS
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if project_root not in sys.path : sys.path.insert(0, project_root)
from logics.general import load_config, get_nats_url, get_gpio_params, get_hardware
from logics.gpio import logic_gpio

#--------------------------------------------------------------------------------- Action
#--------------------------GPIO
gpio = GPIO
gpio.setmode(GPIO.BCM)
gpio.setwarnings(False)

#--------------------------Data
cfg = load_config()
hardware = get_hardware(cfg)

#--------------------------Port
logic = logic_gpio(cfg=cfg)
ports = logic.get_port_mod(mode="in")

#-------------------------- [mode]
for port in ports : 
    print(f"Interrupt | GPIO | pin:{port.get('pin')} | port:{port.get('port')} | mod:{port.get('mode')}")
    gpio.setup(port.get("port"), gpio.IN, pull_up_down=gpio.PUD_DOWN)

#-------------------------- [port_callback]
def port_callback(channel):
    value=gpio.input(channel)
    params = {'protocol': 'gpio', 'port_number': channel, 'value': value}
    print(params)

#-------------------------- [Event]
for port in ports :
    gpio.add_event_detect(port.get("port"), gpio.BOTH, callback=port_callback, bouncetime=200)

#-------------------------- [interrupt]
try:
    while True : time.sleep(1)
except KeyboardInterrupt:
    print("Exiting...")
    gpio.cleanup()