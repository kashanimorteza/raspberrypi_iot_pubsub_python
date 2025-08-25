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

    #-----NATS
    url = get_nats_url(cfg)
    nc = NATS()
    await nc.connect(url)

    #-----Handler
    response = await nc.request(f"{hardware}.gpio.read", b"{'name':'gpio-7'}", timeout=1.0)
    print(response.data.decode())
    await nc.close()

#-------------------------- main
asyncio.run(run())
