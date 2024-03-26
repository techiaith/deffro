# -*- coding: utf-8 -*-
import os
import sys
import yaml
import scipy
import locale
import datasets

import numpy as np

from tqdm import tqdm
from pathlib import Path

from generate_samples import generate_samples

def getpreferredencoding(do_setlocale = True):
    return "UTF-8"

locale.getpreferredencoding = getpreferredencoding



## Download all data

output_dir = "/openwakeword/mit_rirs"
if not os.path.exists(output_dir):
    os.mkdir(output_dir)
    rir_dataset = datasets.Dataset.from_dict({"audio": [str(i) for i in Path(os.path.join("/openwakeword/mit_rirs_source", "MIT_environmental_impulse_responses/16khz")).glob("*.wav")]}).cast_column("audio", datasets.Audio())
    
    # Save clips to 16-bit PCM wav files
    for row in tqdm(rir_dataset):
        name = row['audio']['path'].split('/')[-1]
        output_file=os.path.join(output_dir, name)
        scipy.io.wavfile.write(output_file, 16000, (row['audio']['array']*32767).astype(np.int16))


output_dir = "/openwakeword/audioset_16k"
if not os.path.exists(output_dir):
    os.mkdir(output_dir)

    audioset_dataset = datasets.load_dataset("agkphysics/AudioSet")

    # Save clips to 16-bit PCM wav files
    #audioset_dataset = datasets.Dataset.from_dict({"audio": [str(i) for i in Path("audioset/audio").glob("**/*.flac")]})
    audioset_dataset = audioset_dataset.cast_column("audio", datasets.Audio(sampling_rate=16000))
    #print (audioset_dataset)
    try:
        # can cause a soundfile.LibsndfileError: Internal psf_fseek() failed. error . We should have
        # had enough examples to be able to move on however
        for row in tqdm(audioset_dataset["train"]):
            name = row['audio']['path'].split('/')[-1].replace(".flac", ".wav")
            scipy.io.wavfile.write(os.path.join(output_dir, name), 16000, (row['audio']['array']*32767).astype(np.int16))
    except:
        pass


output_dir = "/openwakeword/fma"
if not os.path.exists(output_dir):
    os.mkdir(output_dir)
    fma_dataset = datasets.load_dataset("rudraml/fma", name="small", split="train", streaming=True)
    fma_dataset = iter(fma_dataset.cast_column("audio", datasets.Audio(sampling_rate=16000)))

    # Save clips to 16-bit PCM wav files
    n_hours = 1  # use only 1 hour of clips for this example notebook, recommend increasing for full-scale training
    for i in tqdm(range(n_hours*3600//30)):  # this works because the FMA dataset is all 30 second clips
        row = next(fma_dataset)
        name = row['audio']['path'].split('/')[-1].replace(".mp3", ".wav")
        scipy.io.wavfile.write(os.path.join(output_dir, name), 16000, (row['audio']['array']*32767).astype(np.int16))
        i += 1
        if i == n_hours*3600//30:
            break
