#!/usr/bin/env python3

import re
from nltk.corpus import cmudict

dictionary = cmudict.dict()

# Count syllables in a word
def nsyl_word(word):
    # See: https://stackoverflow.com/a/4103234/6791398
    return [len(list(y for y in x if y[-1].isdigit())) for
            x in dictionary[word.lower()]]

# Count syllables in a sentence
def nsyl_sentence(sentence):

    # Strip punctuation
    sentence = re.sub(r"([^\s'\w]|_)+", "", sentence)

    # Error on typos
    for word in sentence.split():
        if word.lower() not in dictionary:
            print("Typo in word: " + word + ". Aborting.")
            quit()

    # Count syllables
    count = 0
    for word in sentence.split():
        count += nsyl_word(word)[0]
    return count
