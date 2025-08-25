#--------------------------------------------------------------------------------- Location
# subscriber/gpio.py

#--------------------------------------------------------------------------------- Description
# subscriber gpio

#--------------------------------------------------------------------------------- Import
import os, sys, asyncio
import RPi.GPIO as GPIO
from nats.aio.client import Client as NATS
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if project_root not in sys.path : sys.path.insert(0, project_root)
from logics.general import load_config, get_nats_url, get_msg_dict, get_gpio_params, get_hardware
from logics.gpio import logic_gpio

#--------------------------------------------------------------------------------- Action
#-----Data
cfg = load_config()
hardware = get_hardware(cfg)


#-----GPIO
import RPi.GPIO as GPIO
gpio = GPIO
gpio.setmode(GPIO.BCM)
gpio.setwarnings(False)

#-----Logic
logic = logic_gpio(gpio=gpio, cfg=cfg)
logic.load()

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)
value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)
value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)

value = logic.read(10)
print(value)