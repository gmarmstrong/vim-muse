#!/usr/bin/env bash

sudo pip3 install --upgrade setuptools
sudo pip3 install --upgrade python-datamuse
sudo pip3 install --upgrade nltk
python3 -c "import nltk; nltk.download('cmudict')"
