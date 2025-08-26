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
#--------------------------Data
cfg = load_config()
hardware = get_hardware(cfg)

#--------------------------GPIO
gpio = GPIO
gpio.setmode(GPIO.BCM)
gpio.setwarnings(False)

#--------------------------Pin
logic = logic_gpio(cfg=cfg)
pins = logic.get_port_mod(mode="in")

#-------------------------- [mode]
for pin in pins : 
    print(f"Interrupt GPIO Pin : {pin}")
    gpio.setup(pin, gpio.IN, pull_up_down=gpio.PUD_DOWN)

# #-------------------------- [pin_callback]
# def pin_callback(channel):
#     value=GPIO.input(channel)
#     print(f"{channel} | {value}", flush=True)

#     params = {'protocol': PORT_PROTOCOLS.GPIO, 'port_number': channel, 'value': value}
#     requests.get(f"{url}/raspberrypi/interrupt_load", params=params)

# #-------------------------- [Event]
# for pin in pins : 
#     GPIO.add_event_detect(pin, GPIO.BOTH, callback=pin_callback, bouncetime=200)

# #-------------------------- [interrupt]
# try:
#     while True : time.sleep(1)
# except KeyboardInterrupt:
#     print("Exiting...")
#     GPIO.cleanup()