# #--------------------------------------------------------------------------------- Location
# # logics/hardware_gpio.py

# #--------------------------------------------------------------------------------- Description
# # This is logic for hardware_gpio

# #--------------------------------------------------------------------------------- Import
# import inspect
# from const.debug import debug as const_debug
# from models.py.general import model_output
# from libs.tools import Tools
# from const.microcontroller import PORT_PROTOCOLS, PORT_TYPES, IF_TYPES
# from RPi import GPIO as GPIO
# from models.db.port import port as model_port


# class hardware_gpio:
#     #-------------------------- [Init]
#     def __init__(self, verbose: bool = False, log: bool = False, gpio:GPIO=None):
#         #--------------Variable
#         self.this_class = self.__class__.__name__
#         self.modoule = "hardware_gpio"
#         self.verbose = verbose
#         self.log = log
#         self.tools = Tools()
#         self.gpio = gpio

#     #-------------------------- [load]
#     def load(self, ports:list[model_port]) -> model_output:
#         #--------------Description
#         # IN     : 
#         # OUT    : model_output
#         # Action : Load GPIO 
#         try:
#             #--------------Debug
#             this_method = inspect.currentframe().f_code.co_name
#             verbose = const_debug.get(self.this_class, {}).get(this_method, {}).get('verbose', False)
#             log = const_debug.get(self.this_class, {}).get(this_method, {}).get('log', False)
#             log_model = const_debug.get(self.this_class, {}).get(this_method, {}).get('model', False)
#             output = model_output()
#             #--------------Action
#             for port in ports:
#                 if port.protocol == PORT_PROTOCOLS.GPIO:
#                     if port.type==PORT_TYPES.IN : 
#                         self.gpio.setup(port.port, self.gpio.IN, pull_up_down=self.gpio.PUD_DOWN)
#                     if port.type==PORT_TYPES.OUT : 
#                         self.gpio.setup(port.port, self.gpio.OUT)
#                         self.out(port.port, port.value)
#         except Exception as e:  
#             #--------------Error
#             output.status = False
#             output.data = {"class":self.this_class, "method":this_method, "error": str(e)}
#             print(output)
#             self.tools.log("error",output)
#         #--------------Verbose
#         if verbose : print(output)
#         #--------------Log
#         if log : self.tools.log(log_model, output)
#         #--------------Output
#         return output

#     #-------------------------- [gpio_interrupt]
#     def interrupt(self, ports:list[model_port]) -> model_output:
#         #--------------Description
#         # IN     : 
#         # OUT    : model_output
#         # Action : Load GPIO 
#         try:
#             #--------------Debug
#             this_method = inspect.currentframe().f_code.co_name
#             verbose = const_debug.get(self.this_class, {}).get(this_method, {}).get('verbose', False)
#             log = const_debug.get(self.this_class, {}).get(this_method, {}).get('log', False)
#             log_model = const_debug.get(self.this_class, {}).get(this_method, {}).get('model', False)
#             output = model_output()
#             #--------------Import
#             from const.microcontroller_inctance import microcontroller_instance as microcontroller_instance
#             #--------------Action
#             for port in ports:
#                 if port and port.protocol == PORT_PROTOCOLS.GPIO and port.type == PORT_TYPES.IN:
#                     value = self.inin(port.port).data
#                     microcontroller_instance.interrupt_load(protocol=port.protocol, port_number=port.port, value=value)
#         except Exception as e:  
#             #--------------Error
#             output.status = False
#             output.data = {"class":self.this_class, "method":this_method, "error": str(e)}
#             print(output)
#             self.tools.log("error",output)
#         #--------------Verbose
#         if verbose : print(output)
#         #--------------Log
#         if log : self.tools.log(log_model, output)
#         #--------------Output
#         return output
    
#     #-------------------------- [out]
#     def out(self, port:int, value:int) -> model_output:
#         #--------------Description
#         # IN     : port | value
#         # OUT    : model_output
#         # Action : on or off port of gpio
#         try:
#             #--------------Debug
#             this_method = inspect.currentframe().f_code.co_name
#             verbose = const_debug.get(self.this_class, {}).get(this_method, {}).get('verbose', False)
#             log = const_debug.get(self.this_class, {}).get(this_method, {}).get('log', False)
#             log_model = const_debug.get(self.this_class, {}).get(this_method, {}).get('model', False)
#             output = model_output()
#             #--------------Action
#             self.gpio.output(port, self.gpio.HIGH if value else self.gpio.LOW)
#         except Exception as e:  
#             #--------------Error
#             output.status = False
#             output.data = {"class":self.this_class, "method":this_method, "error": f"{port} | {str(e)}"}
#             print(output)
#             self.tools.log("error",output)
#         #--------------Verbose
#         if verbose : print(output)
#         #--------------Log
#         if log : self.tools.log(log_model, output)
#         #--------------Output
#         return output
    
#     #-------------------------- [inin]
#     def inin(self, port:int) -> model_output:
#         #--------------Description
#         # IN     : port
#         # OUT    : status of gpio
#         # Action : on or off port of gpio
#         try:
#             #--------------Debug
#             this_method = inspect.currentframe().f_code.co_name
#             verbose = const_debug.get(self.this_class, {}).get(this_method, {}).get('verbose', False)
#             log = const_debug.get(self.this_class, {}).get(this_method, {}).get('log', False)
#             log_model = const_debug.get(self.this_class, {}).get(this_method, {}).get('model', False)
#             output = model_output()
#             #--------------Variable
#             value = self.gpio.input(port)
#             #--------------Action
#             output.data = value
#         except Exception as e:  
#             #--------------Error
#             output.status = False
#             output.data = {"class":self.this_class, "method":this_method, "error": f"{port} | {str(e)}"}
#             print(output)
#             self.tools.log("error",output)
#         #--------------Verbose
#         if verbose : print(output)
#         #--------------Log
#         if log : self.tools.log(log_model, output)
#         #--------------Output
#         return output