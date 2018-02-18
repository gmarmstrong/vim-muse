#!/usr/bin/env bash

# Install python-datamuse
if ! python3 -c "import datamuse"; then
    pip3 install python-datamuse
fi

# Install nltk
if ! python3 -c "import nltk"; then
    pip3 install nltk
fi

# Install cmudict for nltk
if ! python3 -c "from nltk.corpus import cmudict"; then
    python3 -c "import nltk; nltk.download('cmudict')"
fi
