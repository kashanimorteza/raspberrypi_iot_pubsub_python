import time
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD)

GPIO.setup(13, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

def pin_callback(channel):
    value = GPIO.input(channel)
    print(f"{channel} | {value}", flush=False)

GPIO.add_event_detect(13, GPIO.BOTH, callback=pin_callback, bouncetime=200)

try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    print("Exiting...")
    GPIO.cleanup()
