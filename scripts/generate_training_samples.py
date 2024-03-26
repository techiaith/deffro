# -*- coding: utf-8 -*-
import locale

import numpy as np

from pathlib import Path
from tqdm import tqdm

from generate_samples import generate_samples

def getpreferredencoding(do_setlocale = True):
    return "UTF-8"

locale.getpreferredencoding = getpreferredencoding

target_word = 'max_en' # @param {type:"string"}

def text_to_speech(text):
    generate_samples(text = text,
                max_samples=1,
                length_scales=[1.1],
                noise_scales=[0.7], noise_scale_ws = [0.7],
                output_dir = './', batch_size=1, auto_reduce_batch_size=True,
                file_names=["test_generation.wav"]
                )

text_to_speech(target_word)
