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
from logics.general import load_config, get_nats_url

#--------------------------------------------------------------------------------- Action
#-------------------------- run
async def run():
    url = get_nats_url()
    nc = NATS()
    await nc.connect(url)

    async def gpio_handler(msg) : print(f"{msg.data.decode()}")
    await nc.subscribe("gpio", cb=gpio_handler)

    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

#-------------------------- main
asyncio.run(run())