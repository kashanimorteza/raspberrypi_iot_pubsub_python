#--------------------------------------------------------------------------------- Location
# publisher/gpio.py

#--------------------------------------------------------------------------------- Description
# publisher gpio

#--------------------------------------------------------------------------------- Import
import os, sys, asyncio
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
    nats_url = get_nats_url(cfg)
    logic = logic_gpio(cfg=cfg)
    ports = logic.get_port_mod(mode="in")
    
    #-------------------------- GPIO
    gpio = GPIO
    gpio.setmode(GPIO.BOARD)
    gpio.setwarnings(False)

    #-------------------------- NATS
    nc = NATS()
    await nc.connect(nats_url)
    loop = asyncio.get_running_loop()

    #-------------------------- CallBack
    def port_callback(pin):
        value = gpio.input(pin)
        subject = f"interrupt.{hardware}.{module}.{pin}.{value}"
        print(f"Interrupt | {module} | Call | {pin} | {value} | {subject}")
        async def _publish():
            try:
                await nc.publish(subject)
            except Exception as e:
                print(f"Publish error: {e}")
        loop.call_soon_threadsafe(lambda: asyncio.create_task(_publish()))

    #-------------------------- Listen
    for port in ports : 
        print(f"Interrupt | {module} | Listen | {port.get('pin')} | {port.get('mode')}")
        #gpio.setup(port.get("pin"), gpio.IN, pull_up_down=gpio.PUD_DOWN)
        gpio.add_event_detect(port.get("pin"), gpio.BOTH, callback=port_callback, bouncetime=200)

    #-------------------------- Run
    try:
        while True:
            await asyncio.sleep(1)
    except KeyboardInterrupt:
        print("Exiting...")
    finally:
        gpio.cleanup()

asyncio.run(run())