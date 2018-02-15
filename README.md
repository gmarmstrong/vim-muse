# `rhymer`

`rhymer` is Vim plugin for writing lyric poetry. It was originally
written as a rhyming assistant and syllable counter for the
[UGAHacks](http://ugahacks.com/) 2018 hackathon.

You can the find documentation by entering `:help rhymer` after installing.

## Example

![Demo recording of rhymer](https://i.imgur.com/eAKCKSR.gif)

## Installation

`rhymer` should work with any plugin manager, but only `vim-plug` is currently
tested or documented here.

1. Install [`vim-plug`](https://github.com/junegunn/vim-plug)
2. Add `Plug 'gmarmstrong/rhymer'` to the `plug` call in your `~/.vimrc`.
3. Restart Vim
4. Enter `:PlugInstall`
5. Use `:call rhymer#Install()` to add syllable support

Use `:PlugUpdate` to update to the latest release
