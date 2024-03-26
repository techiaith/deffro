#!/bin/bash
set -e

set +x
echo "#######################################################################################"
echo "### Setting up training data"
echo "#######################################################################################"
set -x
python3 generate_training_samples.py

python3 download_data.py

python3 create_config.py


set +x
echo "#######################################################################################"
echo "### Generating training clips"
echo "#######################################################################################"
set -x
python3 /openwakeword/openwakeword/openwakeword/train.py --training_config /models/my_custom_model/my_model.yaml --generate_clips

set +x
echo "#######################################################################################"
echo "### Augmenting training clips"
echo "#######################################################################################"
set -x
python3 /openwakeword/openwakeword/openwakeword/train.py --training_config /models/my_custom_model/my_model.yaml --augment_clips

set +x
echo "#######################################################################################"
echo "### Training wake word"
echo "#######################################################################################"
set -x
python3 /openwakeword/openwakeword/openwakeword/train.py --training_config /models/my_custom_model/my_model.yaml --train_model

