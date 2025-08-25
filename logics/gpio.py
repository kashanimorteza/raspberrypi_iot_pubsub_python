#--------------------------------------------------------------------------------- Location
# logics/gpio.py

#--------------------------------------------------------------------------------- Description
# logic for gpio

#--------------------------------------------------------------------------------- Import
from RPi import GPIO as GPIO
from logics.general import get_gpios

#--------------------------------------------------------------------------------- Action
class logic_gpio:
    #-------------------------- [Init]
    def __init__(self, verbose: bool = False, log: bool = False, gpio:GPIO=None):
        #gpio:GPIO=None
        #--------------Variable
        self.this_class = self.__class__.__name__
        self.modoule = "hardware_gpio"
        self.verbose = verbose
        self.log = log
        self.gpio = gpio

    #-------------------------- [load]
    def load(self, cfg) -> bool:
        #--------------Description
        # IN     : cfg=data of config file
        # OUT    : true/false
        # Action : Load GPIO 
        
        #--------------Variable
        output = False

        #--------------Data
        items = get_gpios(cfg)

        #--------------Action
        for item in items:
            mode = item.get("mode")
            port = item.get("port")
            print(f"Load : {mode} : {port}") 
            if mode == "in" :
                self.gpio.setup(port, self.gpio.IN, pull_up_down=self.gpio.PUD_DOWN)
            if mode == "out" : 
                self.gpio.setup(port, self.gpio.OUT)
                self.write(port, 0)

        #--------------Output
        return output

    #-------------------------- [write]
    def write(self, port, value) -> bool:
        #--------------Description
        # IN     : port=gpio port number | value=0/1
        # OUT    : true/false
        # Action : on or off gpio port
        
        #--------------Variable
        output = True

        #--------------Action
        self.gpio.output(port, self.gpio.HIGH if value else self.gpio.LOW)

        #--------------Output
        return output

    #-------------------------- [read]
    def read(self, port) -> bool:
        #--------------Description
        # IN     : port=gpio port number
        # OUT    : a number
        # Action : read gpio port number

        #--------------Action
        output = self.gpio.input(port)

        #--------------Output
        return output