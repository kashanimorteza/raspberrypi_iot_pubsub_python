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
    gpio.setmode(GPIO.BCM)
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
    method = "write"
    print(f"hardware:{hardware} | module:{module} | method:{method}")
    async def gpio_write_handler(msg):
        #-data
        name = msg.subject.split('.')[3]
        value = msg.subject.split('.')[4]
        port = get_gpio_params(cfg, name).get("port")
        #-action
        result = logic.write(port, value)
        #-verbose
        print(f"hardware:{hardware} | module:{module} | method:{method} | name:{name} | port:{port} | value:{value} | result:{result}")
    await nc.subscribe(f"{hardware}.{module}.{method}.>", cb=gpio_write_handler)
    #------------Read
    method = "read"
    print(f"hardware:{hardware} | module:{module} | method:{method}")
    async def gpio_read_handler(msg):
        #-data
        name = msg.subject.split('.')[3]
        port = get_gpio_params(cfg, name).get("port")
        #-action
        value = logic.read(port)
        await nc.publish(msg.reply, str(value).encode())
        #-verbose
        print(f"hardware:{hardware} | module:{module} | method:{method} | name:{name} | port:{port} | value:{value}")
    await nc.subscribe(f"{hardware}.{module}.{method}.>", cb=gpio_read_handler)

    #--------------------------Run
    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

asyncio.run(run())