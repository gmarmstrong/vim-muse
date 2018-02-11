#!/usr/bin/env python3

# Datamuse API documentation: https://www.datamuse.com/api/
# Datamuse API root: https://api.datamuse.com/

# This is a Python library that acts as a wrapper for the Datamuse API's rhyme
# function.

# TODO Add docstrings

import json
import requests


def rhyme(word):
    url = "https://api.datamuse.com/words?rel_rhy="
    response = requests.get(url + word)
    rhymes = json.loads(response.text)
    rhyme_list = []
    for rhyme in rhymes[0:10]:
        rhyme_list.append(rhyme["word"])
    return " ".join(rhyme_list)


def synonym(word):
    url="https://api.datamuse.com/words?ml="
    response = requests.get(url + word)
    synonyms = json.loads(response.text);
    synonym_list = []
    for synonym in synonyms[0:10]:
        synonym_list.append(synonym["word"])
        return " ".join(synonym_list)
