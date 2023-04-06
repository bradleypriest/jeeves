#!/usr/bin/env python3

import os
import sys
from TTS.api import TTS
from pydub.playback import play
from pydub import AudioSegment

# List available 🐸TTS models and choose the first one
model_name = TTS.list_models()[0]
# Init TTS
tts = TTS(model_name)
# Run TTS
# ❗ Since this model is multi-speaker and multi-lingual, we must set the target speaker and the language
# Text to speech with a numpy output
tts.tts_to_file(text=sys.argv[1], speaker=tts.speakers[0], language=tts.languages[0], file_path="tmp/output.wav")
play(AudioSegment.from_wav("tmp/output.wav"))
os.remove('tmp/output.wav')
