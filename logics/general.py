#--------------------------------------------------------------------------------- Location
# logics/general.py

#--------------------------------------------------------------------------------- Description
# general function

#--------------------------------------------------------------------------------- Import
import os
import yaml


#--------------------------------------------------------------------------------- Action
#-------------------------- load_config
def load_config():
    """Load config.yaml from repo root by default, or CONFIG_PATH if set."""
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    config_path = os.environ.get("CONFIG_PATH", os.path.join(root_dir, "config.yaml"))
    with open(config_path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

#-------------------------- get_nats_url
def get_nats_url():
    cfg = load_config()
    nats_cfg = cfg.get("nats", {})
    host = nats_cfg.get("host", "127.0.0.1")
    port = nats_cfg.get("port", 4222)
    return f"nats://{host}:{port}"