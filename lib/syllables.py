#!/usr/bin/env python3

import string
from nltk.corpus import cmudict

# Count syllables in a word
def nsyl_word(word):
    # See: https://stackoverflow.com/a/4103234/6791398
    d = cmudict.dict()
    return [len(list(y for y in x if y[-1].isdigit())) for x in d[word.lower()]]

# Count syllables in a sentence
def nsyl_sentence(sentence):
    # Strip punctuation
    sentence = "".join((char for char in sentence if
        char not in string.punctuation))

    # Count syllables
    count = 0
    for word in sentence.split():
        count += nsyl_word(word)[0]
    return count
