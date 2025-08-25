#--------------------------------------------------------------------------------- Location
# subscriber/gpio.py

#--------------------------------------------------------------------------------- Description
# subscriber gpio

#--------------------------------------------------------------------------------- Import
import os, sys, asyncio
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
        msg = get_msg_dict(msg)
        name = msg.get("name")
        value = msg.get("value")
        if name is not None and value is not None:
            item = get_gpio_params(cfg, name)
            mode = item.get("mode")
            if mode == "out":
                print(mode)
    await nc.subscribe("gpio", cb=gpio_handler)

    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

#-------------------------- main
asyncio.run(run())