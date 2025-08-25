#--------------------------------------------------------------------------------- Location
# logics/gpio.py

#--------------------------------------------------------------------------------- Description
# logic for gpio

#--------------------------------------------------------------------------------- Import
from RPi import GPIO as GPIO
from logics.general import get_gpios, load_config

#--------------------------------------------------------------------------------- Action
class logic_gpio:
    #-------------------------- [Init]
    def __init__(self, verbose: bool = False, log: bool = False, gpio:GPIO=None, cfg=None):
        #--------------Variable
        self.this_class = self.__class__.__name__
        self.modoule = "logic_gpio"
        self.verbose = verbose
        self.log = log
        self.gpio = gpio
        self.cfg = cfg

    #-------------------------- [load]
    def load(self) -> bool:
        #--------------Description
        # IN     : cfg=data of config file
        # OUT    : true/false
        # Action : Load GPIO 
        
        #--------------Variable
        result = False

        #--------------Data
        items = get_gpios(self.cfg)

        #--------------Action
        for item in items:
            mode = item.get("mode")
            port = item.get("port")
            print(f"GPIO : load : {mode} : {port}") 
            if mode == "in" :
                self.gpio.setup(port, self.gpio.IN, pull_up_down=self.gpio.PUD_DOWN)
            if mode == "out" : 
                self.gpio.setup(port, self.gpio.OUT)
                self.write(port, 0)

        #--------------Output
        return result

    #-------------------------- [write]
    def write(self, port, value) -> bool:
        #--------------Description
        # IN     : port=gpio port number | value=0/1
        # OUT    : true/false
        # Action : on or off gpio port
        
        #--------------Action
        self.gpio.output(port, self.gpio.HIGH if value else self.gpio.LOW)

        #--------------Result
        result = f"GPIO : write : {port} : {value}"

        #--------------Output
        return result

    #-------------------------- [read]
    def read(self, port) -> bool:
        #--------------Description
        # IN     : port=gpio port number
        # OUT    : a number
        # Action : read gpio port number

        #--------------Action
        result = self.gpio.input(port)
        
        #--------------Output
        return result