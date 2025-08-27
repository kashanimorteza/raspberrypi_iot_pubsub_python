#--------------------------------------------------------------------------------- Location
# logics/chip.py

#--------------------------------------------------------------------------------- Description
# start chip

#--------------------------------------------------------------------------------- Import
import os, sys
import RPi.GPIO as GPIO
project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if project_root not in sys.path : sys.path.insert(0, project_root)
from logics.general import load_config
from logics.gpio import logic_gpio

#--------------------------------------------------------------------------------- Action
#--------------------------Data
cfg = load_config()

#--------------------------GPIO
gpio = GPIO
gpio.setmode(GPIO.BOARD)
gpio.setwarnings(False)

#--------------------------Logic
logic = logic_gpio(gpio=gpio, cfg=cfg)
logic.load(mode="out")
logic.load(mode="in")