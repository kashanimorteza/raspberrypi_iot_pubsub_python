#--------------------------------------------------------------------------------- Location
# logics/gpio.py

#--------------------------------------------------------------------------------- Description
# logic for gpio

#--------------------------------------------------------------------------------- Import
from RPi import GPIO as GPIO

#--------------------------------------------------------------------------------- Action
class logic_gpio:
    #-------------------------- [Init]
    def __init__(self, verbose: bool = False, log: bool = False, gpio:GPIO=None, cfg=None):
        #--------------Variable
        self.this_class = self.__class__.__name__
        self.modoule = "logic_gpio"
        self.name = "gpio"
        self.verbose = verbose
        self.log = log
        self.gpio = gpio
        self.cfg = cfg

    #-------------------------- get_gpios
    def get_gpios(self):
        chip = self.cfg.get("chip", {})
        gpios = chip.get("gpio", {})
        if not isinstance(gpios, dict):
            return []
        items = []
        for name, spec in gpios.items():
            if isinstance(spec, dict):
                item = dict(spec)
                item.setdefault("name", name)
                items.append(item)
        return items

    #-------------------------- [get_port_mod]
    def get_port_mod(self, mode):
        #--------------Description
        # IN     : mode=in/out
        # OUT    : list of pins
        # Action : check port that = mode

        #--------------Variable
        result = []

        #--------------Data
        items = self.get_gpios()

        #--------------Action
        for item in items:
            if item.get("mode") == mode : 
                result.append(item)

        #--------------Output
        return result

    #-------------------------- [load]
    def load(self,mode) -> bool:
        #--------------Description
        # IN     : cfg=data of config file
        # OUT    : true/false
        # Action : Load GPIO 
        
        #--------------Variable
        result = False

        #--------------Data
        items = self.get_gpios()

        #--------------Action
        for item in items:
            port_mode = item.get("mode")
            pin = item.get("pin") 
            if port_mode == mode:
                if mode == "in" :
                    self.gpio.setup(pin, self.gpio.IN, pull_up_down=self.gpio.PUD_DOWN)
                if mode == "out" : 
                    self.gpio.setup(pin, self.gpio.OUT)
                    self.write(pin, 0)
                print(f"{self.name} : load : {pin} : {port_mode}")
        #--------------Output
        return result

    #-------------------------- [write]
    def write(self, pin, value) -> bool:
        #--------------Description
        # IN     : pin=gpio pin number | value=0/1
        # OUT    : true/false
        # Action : on or off gpio pin

        #--------------Variable
        result = True
        
        #--------------Action
        self.gpio.output(pin, self.gpio.HIGH if value else self.gpio.LOW)

        #--------------Output
        return result

    #-------------------------- [read]
    def read(self, pin) -> bool:
        #--------------Description
        # IN     : pin=gpio pin number
        # OUT    : value
        # Action : read gpio pin value

        #--------------Action
        result = self.gpio.input(pin)
        
        #--------------Output
        return result