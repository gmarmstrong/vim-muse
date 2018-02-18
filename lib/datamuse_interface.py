#!/usr/bin/env python3

import argparse
from datamuse import datamuse
import importlib.util
import json
import os

api = datamuse.Datamuse()
parser = argparse.ArgumentParser()
parser.add_argument("param")
parser.add_argument("words")
args = parser.parse_args()

payload = {args.param: args.words, "max": 10}
results = api.words(**payload)
result_list = []
for result in results:
    result_list.append(result["word"])
print(" ".join(result_list))
