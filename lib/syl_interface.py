#!/usr/bin/env python3

# Interfaces with syllables.py

import argparse
import syllables

parser = argparse.ArgumentParser()
parser.add_argument("words")
args = parser.parse_args()
print(syllables.nsyl_sentence(args.words))
