#--------------------------------------------------------------------------------- Location
# publisher/gpio.py

#--------------------------------------------------------------------------------- Description
# publisher gpio

#--------------------------------------------------------------------------------- Import
import os, sys, time, asyncio
import RPi.GPIO as GPIO
from nats.aio.client import Client as NATS
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if project_root not in sys.path : sys.path.insert(0, project_root)
from logics.general import load_config, get_hardware, get_nats_url
from logics.gpio import logic_gpio

#--------------------------------------------------------------------------------- Action
async def run():
    #-------------------------- Variable
    module = "gpio"

    #-------------------------- Data
    cfg = load_config()
    hardware = get_hardware(cfg)

    #-------------------------- GPIO
    gpio = GPIO
    gpio.setmode(GPIO.BOARD)
    gpio.setwarnings(False)

    #-------------------------- NATS
    url = get_nats_url(cfg)
    nc = NATS()
    await nc.connect(url)

    #-------------------------- Logic
    logic = logic_gpio(cfg=cfg)
    ports = logic.get_port_mod(mode="in")

    #-------------------------- Listen
    for port in ports : 
        print(f"{hardware} | Interrupt | {module} | Listen | pin:{port.get('pin')} | port:{port.get('port')} | mod:{port.get('mode')}")
        gpio.setup(port.get("pin"), gpio.IN, pull_up_down=gpio.PUD_DOWN)

    #-------------------------- CallBack
    def port_callback(pin):
        value=gpio.input(pin)
        print(f"{hardware} | Interrupt | {module} | CallBack | pin:{pin} | value:{value}")
        print(f"interrupt.{hardware}.{module}.{pin}.{value}")
        port_publish()

    #-------------------------- Publish
    async def port_publish():
        await nc.publish(f"interrupt.{hardware}.{module}.19.1", b"aaaaa")
    
    #-------------------------- Handler
    for port in ports :
        gpio.add_event_detect(port.get("pin"), gpio.BOTH, callback=port_callback, bouncetime=200)

    #--------------------------Run
    try:
        while True : time.sleep(1)
    except KeyboardInterrupt:
        print("Exiting...")
        gpio.cleanup()

asyncio.run(run())