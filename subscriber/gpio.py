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
async def run():

    #--------------------------Variable
    module = "gpio"
    result = False
    
    #--------------------------Data
    cfg = load_config()
    hardware = get_hardware(cfg)

    #--------------------------GPIO
    import RPi.GPIO as GPIO
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
    print(f"{hardware}.{module}.write")
    async def gpio_write_handler(msg):
        #-data
        name = msg.subject.split('.')[-1]
        value = get_msg_dict(msg.data).get("value")
        port = get_gpio_params(cfg, name).get("port")
        #-action
        result = logic.write(port, value)
        #-verbose
        print(f"hardware:{hardware} | module:{module} | method:write | name:{name} | port:{port} | value:{value} | result:{result}")
    await nc.subscribe(f"{hardware}.{module}.write.*", cb=gpio_write_handler)
    #------------Read
    print(f"{hardware}.{module}.read")
    async def gpio_read_handler(msg):
        #-data
        name = msg.subject.split('.')[-1]
        port = get_gpio_params(cfg, name).get("port")
        #-action
        value = logic.read(port)
        await nc.publish(msg.reply, str(value).encode())
        #-verbose
        print(f"hardware:{hardware} | module:{module} | method:read | name:{name} | port:{port} | value:{value}")
    await nc.subscribe(f"{hardware}.{module}.read.*", cb=gpio_read_handler)

    #--------------------------Run
    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

asyncio.run(run())