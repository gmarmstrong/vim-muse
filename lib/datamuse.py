#!/usr/bin/env python3

# DataMuse API documentation: https://www.datamuse.com/api/
# DataMuse API root: https://api.datamuse.com/

# This is a Python library that acts as a wrapper for the DataMuse API's rhyme
# function.

import os
import json
import requests


"""Get a synonym of an inputted word from the muse API

Keyword arguments:
word - the word to find synonyms for

return:
A list of strings that rhyme with the word
"""

def rhyme(word):
    url = "https://api.datamuse.com/words?rel_rhy="
    response = requests.get(url + word)
    rhymes = json.loads(response.text)
    rhyme_list = []
    for rhyme in rhymes[0:8]:
        rhyme_list.append(rhyme["word"])
    return " ".join(rhyme_list)


rhyming_word = os.environ['RHYMING_WORD']
rhymes = rhyme(rhyming_word)
print(rhymes)

"""Get a synonym of an inputted word from the muse API

Keyword arguments:
word - the word to find synonyms for

return:
A list of strings that are synonymous with the word
"""
def synonym(word):
    url="https://api.datamuse.com/words?ml="
    response = requests.get(url + word)
    synonyms = json.loads(response.text);
    synonym_list = []
    for synonym in synonyms[0:8]:
        synonym_list.append(synonym["word"])
        return " ".join(synonym_list)


"""Set the environment variables and print the synonym list."""
synonymous_word = os.environ['SYNONYMOUS_WORD']
synonyms = synonym(synonymous_word)
print(synonyms)


