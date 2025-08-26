#--------------------------------------------------------------------------------- Location
# publisher/gpio.py

#--------------------------------------------------------------------------------- Description
# publisher gpio

#--------------------------------------------------------------------------------- Import
import os, sys, asyncio, time
import RPi.GPIO as gpio

#-------------------------- [port_callback]
def port_callback(channel):
    pass

gpio.setmode(gpio
.BOARD)
gpio.setwarnings(False)
gpio.setup(13, gpio.IN, pull_up_down=gpio.PUD_DOWN)
gpio.add_event_detect(13, gpio.BOTH, callback=port_callback, bouncetime=200)

try:
    while True : time.sleep(1)
except KeyboardInterrupt:
    print("Exiting...")
    gpio.cleanup()