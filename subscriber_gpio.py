#--------------------------------------------------------------------------------- Location
# subscriber_gpio.py

#--------------------------------------------------------------------------------- Description
# subscriber gpio

#--------------------------------------------------------------------------------- Import
import os
import asyncio
import yaml
from nats.aio.client import Client as NATS

#--------------------------------------------------------------------------------- Action
#-------------------------- load_config
def load_config():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.environ.get("CONFIG_PATH", os.path.join(base_dir, "config.yaml"))
    with open(config_path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

#-------------------------- run
async def run():
    cfg = load_config()
    nats_cfg = cfg.get("nats", {})
    host = nats_cfg.get("host", "127.0.0.1")
    port = nats_cfg.get("port", 4222)
    url = f"nats://{host}:{port}"

    nc = NATS()
    await nc.connect(url)

    async def gpio_handler(msg):
        print(f"[gpio] got: {msg.data.decode()}")

    await nc.subscribe("gpio", cb=gpio_handler)

    try:
        while True:
            await asyncio.sleep(1)
    finally:
        await nc.drain()

#-------------------------- main
asyncio.run(run())