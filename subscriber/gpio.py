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
from logics.general import load_config, get_nats_url, get_gpio_params, get_hardware
from logics.gpio import logic_gpio

#--------------------------------------------------------------------------------- Action
async def run():

    #--------------------------Variable
    module = "gpio"
    
    #--------------------------Data
    cfg = load_config()
    hardware = get_hardware(cfg)

    #--------------------------GPIO
    gpio = GPIO
    gpio.setmode(GPIO.BOARD)
    gpio.setwarnings(False)

    #--------------------------NATS
    url = get_nats_url(cfg)
    nc = NATS()
    await nc.connect(url)

    #--------------------------Logic
    logic = logic_gpio(gpio=gpio, cfg=cfg)
    logic.load()
    
    #--------------------------Handler
    #------------Write
    print(f"{module} : write")
    async def gpio_write_handler(msg):
        #-data
        name = msg.subject.split('.')[3]
        value = msg.subject.split('.')[4]
        pin = get_gpio_params(cfg, name).get("pin")
        #-action
        result = logic.write(pin, value)
        #-verbose
        print(f"{module} | write | {name} | {pin} | {value} | {result}")
    await nc.subscribe(f"{hardware}.{module}.write.>", cb=gpio_write_handler)
    #------------Read
    print(f"{module} : read")
    async def gpio_read_handler(msg):
        #-data
        name = msg.subject.split('.')[3]
        pin = get_gpio_params(cfg, name).get("pin")
        #-action
        value = logic.read(pin)
        await nc.publish(msg.reply, str(value).encode())
        #-verbose
        print(f"{module} | read | {name} | {pin} | {value}")
    await nc.subscribe(f"{hardware}.{module}.read.>", cb=gpio_read_handler)

    #--------------------------Run
    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

asyncio.run(run())