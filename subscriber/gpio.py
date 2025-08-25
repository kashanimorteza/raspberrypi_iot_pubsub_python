#--------------------------------------------------------------------------------- Location
# subscriber/gpio.py

#--------------------------------------------------------------------------------- Description
# subscriber gpio

#--------------------------------------------------------------------------------- Import
import os, sys, re, json
import asyncio
from nats.aio.client import Client as NATS

project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if project_root not in sys.path : sys.path.insert(0, project_root)
from logics.general import load_config, get_nats_url, get_msg_dict, get_gpio_params

#--------------------------------------------------------------------------------- Action
#-------------------------- run
async def run():
    cfg = load_config()
    url = get_nats_url(cfg)
    nc = NATS()
    await nc.connect(url)

    async def gpio_handler(msg):
        print(f"msg : {msg}")
        d = get_msg_dict(msg)
        print(f"d : {d}")
        name = d.get("name")
        value = d.get("value")
        if name is not None and value is not None:
            #item = get_gpio_params(cfg, name)
            print(name)
    await nc.subscribe("gpio", cb=gpio_handler)

    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

#-------------------------- main
asyncio.run(run())