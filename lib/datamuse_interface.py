#!/usr/bin/env python3

import os
import json
import argparse
import importlib.util

# Import datamuse.py
curr_path = os.path.dirname(os.path.realpath(__file__))
datamuse_path = curr_path + "/python-datamuse/datamuse/datamuse.py"
spec = importlib.util.spec_from_file_location("datamuse", datamuse_path)
datamuse = importlib.util.module_from_spec(spec)
spec.loader.exec_module(datamuse)

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
