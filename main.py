#!/usr/bin/env python3

import datamuse
import os

rhyming_word = os.environ['RHYMING_WORD']
rhymes = datamuse.rhyme(rhyming_word)
print(rhymes)
