#!/usr/bin/env bash

# Install nltk
if ! python3 -c "import nltk"; then
    pip3 install nltk
fi

# Install cmudict
if ! python3 -c "from nltk.corpus import cmudict"; then
    python3 -c "import nltk; nltk.download('cmudict')"
fi

echo "Success!"
