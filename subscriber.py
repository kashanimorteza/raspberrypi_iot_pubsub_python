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
from logics.general import load_config, get_nats_url, get_hardware, get_msg_dict
from logics.gpio import logic_gpio
import logics.chip 

#--------------------------------------------------------------------------------- Action
async def run():
    #--------------------------GPIO
    gpio = GPIO
    gpio.setmode(GPIO.BOARD)
    gpio.setwarnings(False)

    #--------------------------Data
    cfg = load_config()
    hardware = get_hardware(cfg)

    #--------------------------Instance
    logic_gpio_instance = logic_gpio(gpio=gpio, cfg=cfg)
    
    #--------------------------NATS
    url = get_nats_url(cfg)
    nc = NATS()
    await nc.connect(url)
    
    #--------------------------Handler
    async def handler(msg):
        #---Data
        data = get_msg_dict(msg)
        protocol = data.get("protocol")
        method = data.get("method")
        address = data.get("address")
        value = data.get("value")
        #---Action
        if protocol == "gpio":
            if method == "write":
                result = logic_gpio_instance.write(address, value)
            if method == "read":
                result = logic_gpio_instance.read(address)
                await nc.publish(msg.reply, str(result).encode())
        #---Verbose
        print(f"{hardware} | {protocol} | {method} | {address} | {value} | {result}")
    await nc.subscribe(f"{hardware}.in", cb=handler)

    #--------------------------Run
    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

asyncio.run(run())