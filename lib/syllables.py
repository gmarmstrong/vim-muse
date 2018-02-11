#!/usr/bin/env python3

from nltk.corpus import cmudict

d = cmudict.dict()

def nsyl_word(word):
    return [len(list(y for y in x if y[-1].isdigit())) for x in d[word.lower()]]

def nsyl_sentence(sentence):
    count = 0
    for word in sentence.split():
        count += nsyl_word(word)[0]
    return count
