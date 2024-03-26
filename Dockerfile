FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

RUN apt update -q \
 && apt install -y -qq tzdata bash git git-lfs wget curl \
                    python3 python3-pip \
 && python3 -m pip install --upgrade pip \
 && apt clean -q

#
WORKDIR /openwakeword

RUN git clone https://github.com/rhasspy/piper-sample-generator
RUN wget -O piper-sample-generator/models/en_US-libritts_r-medium.pt 'https://github.com/rhasspy/piper-sample-generator/releases/download/v2.0.0/en_US-libritts_r-medium.pt'

ENV PATH="$PATH:/openwakeword/piper-sample-generator"
ENV PYTHONPATH "$PYTHONPATH:/openwakeword/piper-sample-generator"

RUN pip install piper-phonemize webrtcvad protobuf==3.20.*

#
RUN git clone https://github.com/dscripka/openwakeword \
 && pip install -e ./openwakeword \
 && cd openwakeword \
 && pip install mutagen==1.47.0 torchinfo==1.8.0 torchmetrics==1.2.0 \
                speechbrain==0.5.14 audiomentations==0.33.0 torch-audiomentations==0.11.0 \
                acoustics==0.2.6 tensorflow-cpu==2.8.1 tensorflow_probability==0.16.0 \
                onnx_tf==1.10.0 pronouncing==0.2.0 datasets==2.14.6 deep-phonemizer==0.0.19 \
 && pip uninstall tensorflow -y

WORKDIR /openwakeword/openwakeword/openwakeword/resources/models
RUN wget https://github.com/dscripka/openWakeWord/releases/download/v0.5.1/embedding_model.onnx -O embedding_model.onnx
RUN wget https://github.com/dscripka/openWakeWord/releases/download/v0.5.1/embedding_model.tflite -O embedding_model.tflite
RUN wget https://github.com/dscripka/openWakeWord/releases/download/v0.5.1/melspectrogram.onnx -O melspectrogram.onnx
RUN wget https://github.com/dscripka/openWakeWord/releases/download/v0.5.1/melspectrogram.tflite -O melspectrogram.tflite

WORKDIR /openwakeword/mit_rirs_source
RUN git clone https://huggingface.co/datasets/davidscripka/MIT_environmental_impulse_responses

WORKDIR /openwakeword
RUN wget https://huggingface.co/datasets/davidscripka/openwakeword_features/resolve/main/openwakeword_features_ACAV100M_2000_hrs_16bit.npy
RUN wget https://huggingface.co/datasets/davidscripka/openwakeword_features/resolve/main/validation_set_features.npy

COPY scripts/* .
