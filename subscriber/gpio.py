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
from logics.general import load_config, get_nats_url, get_msg_dict, get_gpio_params
from logics.gpio import logic_gpio

#--------------------------------------------------------------------------------- Action
#-------------------------- run
async def run():

    #-----GPIO
    import RPi.GPIO as GPIO
    gpio = GPIO
    gpio.setmode(GPIO.BCM)
    gpio.setwarnings(False)

    #-----NATS
    cfg = load_config()
    url = get_nats_url(cfg)
    nc = NATS()
    await nc.connect(url)

    #-----Logic
    logic = logic_gpio(gpio=gpio)
    logic.load(cfg)

    #--------------Variable
    result = False
    
    #-----Handler
    async def gpio_handler(msg):
        msg = get_msg_dict(msg)
        name = msg.get("name")
        value = msg.get("value")
        if name is not None and value is not None:
            item = get_gpio_params(cfg, name)
            mode = item.get("mode")
            port = item.get("port")
            if mode == "out" : 
                result = logic.write(port, value)
                print(result)
    await nc.subscribe("gpio", cb=gpio_handler)

    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

#-------------------------- main
asyncio.run(run())