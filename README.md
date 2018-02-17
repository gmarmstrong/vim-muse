# `vim-muse`

`muse` is Vim plugin for writing poetry and prose. It was originally written as
a rhyming assistant and syllable counter for the
[UGAHacks](http://ugahacks.com/) 2018 hackathon.

You can the find documentation in `doc/muse.txt`, or by entering `:help muse`
after installing.

## Example

![Demo recording of muse](https://i.imgur.com/eAKCKSR.gif)

## Installation

`muse` should work with any plugin manager, but only `vim-plug` is currently
tested or documented here.

1. Install [`vim-plug`](https://github.com/junegunn/vim-plug)
2. Add `Plug 'gmarmstrong/vim-muse'` to the `plug` call in your `~/.vimrc`.
3. Restart Vim
4. Enter `:PlugInstall`
5. Use `:call muse#Install()` to add syllable support

Use `:PlugUpdate` to update to the latest release
