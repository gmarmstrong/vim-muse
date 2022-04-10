[![Build Status](https://api.travis-ci.com/gmarmstrong/vim-muse.svg?branch=master)](https://app.travis-ci.com/gmarmstrong/vim-muse)

# muse

muse is a Vim plugin for writing poetry and prose. It provides features such as
AABB rhyme suggestions, synonym replacement, and syllable counting. It was
originally written under the name rhymer as a rhyming assistant and syllable
counter for the UGAHacks 2018 hackathon.

Usage instructions are included in the `doc/` directory, and are also available
with `:help muse`.

## Installation with vim-plug

1. Install [vim-plug](https://github.com/junegunn/vim-plug)
2. Add `Plug 'gmarmstrong/vim-muse'` to the `plug` call in your `~/.vimrc`
3. Restart Vim or enter `:source $MYVIMRC`
4. Enter `:PlugInstall vim-muse`
5. Restart Vim or enter `:source $MYVIMRC`
6. Install Python 3 packages `python-datamuse` and `nltk`. Either:
    - Enter `:MuseInstall` if using `pip3`, or...
    - Install `python-datamuse` and `nltk` from PyPI and run
      `nltk.download('cmudict')` in Python 3

## Updating

1. Enter `:PlugUpdate vim-muse`
2. Enter `:MuseUpdate` if using `pip3`, or upgrade `python-datamuse` and `nltk`
   from PyPI
