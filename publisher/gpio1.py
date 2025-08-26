import time
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)

GPIO.setup(17, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

def pin_callback(channel):
    value=GPIO.input(channel)
    print(f"{channel} | {value}", flush=True)


GPIO.add_event_detect(17, GPIO.BOTH, callback=pin_callback, bouncetime=200)

try:
    while True : time.sleep(1)
except KeyboardInterrupt:
    print("Exiting...")
    GPIO.cleanup()