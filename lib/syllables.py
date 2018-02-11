#!/usr/bin/env python3

import nltk
from nltk.corpus import cmudict

dictionary = cmudict.dict()

# Count syllables in a word
def nsyl_word(word):
    # See: https://stackoverflow.com/a/4103234/6791398
    return [len(list(y for y in x if y[-1].isdigit())) for x in dictionary[word.lower()]]

# Count syllables in a sentence
def nsyl_sentence(sentence):
    tokens = nltk.word_tokenize(sentence)

    for token in tokens:
        if token.lower() not in dictionary:
            print("Typo in word: " + token + ". Aborting.")
            quit()

    # Count syllables
    count = 0
    for token in tokens:
        count += nsyl_word(token)[0]
    return count
