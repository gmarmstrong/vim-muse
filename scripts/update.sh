#!/usr/bin/env bash

sudo pip3 install --upgrade setuptools
sudo pip3 install python-datamuse --upgrade
sudo pip3 install nltk --upgrade
python3 -c "import nltk; nltk.download('cmudict')"
