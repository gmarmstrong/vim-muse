[![Build Status](https://travis-ci.org/gmarmstrong/vim-muse.svg?branch=master)](https://travis-ci.org/gmarmstrong/vim-muse)

# muse

muse is a Vim plugin for writing poetry and prose. It provides features such as
AABB rhyme suggestions, synonym replacement, and syllable counting. It was
originally written under the name `rhymer` as a rhyming assistant and syllable
counter for the UGAHacks 2018 hackathon.

Usage instructions are included in the `doc/` directory, and are also available
with `:help muse`.

## Installation

1. Install [`vim-plug`](https://github.com/junegunn/vim-plug)
2. Add `Plug 'gmarmstrong/vim-muse'` to the `plug` call in your `~/.vimrc`.
3. Restart Vim
4. Enter `:PlugInstall`
5. Restart Vim
5. Enter `:MuseInstall`

## Updating

Use `:PlugUpdate vim-muse` to update to the latest release of `muse`, and use
`:MuseUpdate` to update its dependencies.
