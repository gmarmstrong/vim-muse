#!/usr/bin/env bash

# Install nltk
if ! python3 -c "import nltk"; then
    pip3 install nltk
fi

# Install cmudict
if ! python3 -c "from nltk.corpus import cmudict"; then
    python3 -c "import nltk; nltk.download('cmudict')"
fi

# Install python-datamuse submodule requirements
CURR_PATH="`dirname \"$0\"`"    # Relative path to this file
sudo pip3 install -r "$CURR_PATH/lib/python-datamuse/requirements.txt"
