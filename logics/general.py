#--------------------------------------------------------------------------------- Location
# logics/general.py

#--------------------------------------------------------------------------------- Description
# general function

#--------------------------------------------------------------------------------- Import
import os, re, json
import yaml

#--------------------------------------------------------------------------------- Action
#-------------------------- load_config
def load_config():
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    config_path = os.environ.get("CONFIG_PATH", os.path.join(root_dir, "config.yaml"))
    with open(config_path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

#-------------------------- get_nats_url
def get_nats_url(cfg):
    nats_cfg = cfg.get("nats", {})
    host = nats_cfg.get("host", "127.0.0.1")
    port = nats_cfg.get("port", 4222)
    return f"nats://{host}:{port}"

#-------------------------- get_gpio_params
def get_gpio_params(cfg, gpio_name):
    chip = cfg.get("chip", {})
    gpios = chip.get("gpio", {})
    if not isinstance(gpios, dict):
        return {}
    entry = gpios.get(str(gpio_name))
    return entry if isinstance(entry, dict) else {}

#-------------------------- get_msg_dict
def get_msg_dict(msg):
    # Extract bytes from msg
    data = None
    if hasattr(msg, "data"):
        data = msg.data
    elif isinstance(msg, (bytes, bytearray)):
        data = msg
    elif isinstance(msg, str):
        data = msg.encode("utf-8")
    if data is None:
        return {}

    try:
        text = data.decode("utf-8").strip()
    except Exception:
        return {}

    # Try JSON first
    try:
        obj = json.loads(text)
        if isinstance(obj, dict):
            return obj
    except Exception:
        pass

    # Try YAML (handles {name: gpio-1, value: 1})
    try:
        obj = yaml.safe_load(text)
        if isinstance(obj, dict):
            return obj
    except Exception:
        pass

    # Normalize single-quoted JSON-like to valid JSON and retry
    if text.startswith("{") and text.endswith("}"):
        try:
            # Replace single-quoted keys/values with double quotes conservatively
            normalized = re.sub(r"'([^']*)'", r'"\\1"', text)
            obj = json.loads(normalized)
            if isinstance(obj, dict):
                return obj
        except Exception:
            pass

    # Fallback: parse key:value pairs (name:gpio-1 value:1)
    pairs = re.findall(r"([A-Za-z0-9_-]+)\s*[:=]\s*([A-Za-z0-9._-]+)", text)
    if pairs:
        out = {k: v for k, v in pairs}
        # Attempt simple numeric conversion for common fields
        for key in list(out.keys()):
            val = out[key]
            try:
                if val.isdigit():
                    out[key] = int(val)
                elif val.replace('.', '', 1).isdigit() and val.count('.') < 2:
                    out[key] = float(val)
            except Exception:
                pass
        return out

    return {}

