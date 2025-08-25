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
#-------------------------- run
async def run():

    #-----Data
    cfg = load_config()
    hardware = get_hardware(cfg)

    #-----GPIO
    import RPi.GPIO as GPIO
    gpio = GPIO
    gpio.setmode(GPIO.BCM)
    gpio.setwarnings(False)

    #-----NATS
    url = get_nats_url(cfg)
    nc = NATS()
    await nc.connect(url)

    #-----Logic
    logic = logic_gpio(gpio=gpio, cfg=cfg)
    logic.load()

    #-----Variable
    result = False
    
    #-----Handler
    print(f"{hardware}.gpio.write")
    async def gpio_write_handler(msg):
        #-msg
        msg = get_msg_dict(msg)
        name = msg.get("name")
        value = msg.get("value")
        #-item
        item = get_gpio_params(cfg, name)
        port = item.get("port")
        #-action
        result = logic.write(port, value)
        #-verbose
        print(result)
    await nc.subscribe(f"{hardware}.gpio.write", cb=gpio_write_handler)

    print(f"{hardware}.gpio.read")
    async def gpio_read_handler(msg):
        #-msg
        subject = msg.subject
        reply = msg.reply
        data = msg.data
        msg = get_msg_dict(msg)
        name = msg.get("name")
        #-item
        item = get_gpio_params(cfg, name)
        port = item.get("port")
        #-action
        value = logic.read(port)
        await nc.publish(reply, str(value).encode())
        #-verbose
        print(f"GPIO : read : {name} : {port} : {value}")
    await nc.subscribe(f"{hardware}.gpio.read", cb=gpio_read_handler)

    #-----Run
    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

#-------------------------- main
asyncio.run(run())