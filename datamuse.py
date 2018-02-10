#!/usr/bin/env python3

# DataMuse API documentation: https://www.datamuse.com/api/
# DataMuse API root: https://api.datamuse.com/

# This is a Python library that acts as a wrapper for the DataMuse API's rhyme
# function.

import json
import requests

def rhyme(word):
    url = "https://api.datamuse.com/words?rel_rhy="
    response = requests.get(url + word)
    rhymes = json.loads(response.text)
    rhyme_list = []
    for rhyme in rhymes[0:8]:
        rhyme_list.append(rhyme["word"])
    return " ".join(rhyme_list)
