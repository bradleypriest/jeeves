#!/usr/bin/env python3

import time
import speech_recognition as sr
# import signal
import sys

def handle_message(message):
    print(f'Message:{message}')

# this is called from the background thread
def callback(recognizer, audio):
    try:
        message = recognizer.recognize_whisper(audio)
        handle_message(message)
    except sr.UnknownValueError:
        print("Could not understand audio")

def listen():
    r = sr.Recognizer()
    m = sr.Microphone()
    with m as source:
      r.adjust_for_ambient_noise(source)

    print("Now Listening")
    stop_listening = r.listen_in_background(m, callback)

    while True:
        sys.stdout.flush()
        time.sleep(0.5)

    # def signal_handler(sig, frame):
    #   print("Shutting down")
    #   stop_listening(wait_for_stop=False)
    #   sys.exit(0)

    # signal.signal(signal.SIGINT, signal_handler)
    # signal.pause()

listen()
