# `rhymer`

The `rhymer` plugin is a rhyming assistant for the Vim text editor. It was
written for [UGAHacks](http://ugahacks.com/) 2018.

## Example

[![asciicast](https://asciinema.org/a/Yp0GhGvtQBFKiASeBxUtYsYqe.png)](https://asciinema.org/a/Yp0GhGvtQBFKiASeBxUtYsYqe)

## Installation

1. Install [`vim-plug`](https://github.com/junegunn/vim-plug)
2. Add `Plug 'gmarmstrong/rhymer'` to the `plug` call in your `~/.vimrc`.
3. Restart Vim
4. Enter `:PlugInstall`

Use `:PlugUpdate` to update to the latest release.

## Usage

### Rhyming (in AA/BB)

1. Put the cursor below the line with which you want to rhyme
2. Hit `<leader>r` (usually `\r`)
3. Select a word

### Syllable counting

1. Put the cursor on the line of which to count the syllables
2. Hit `<leader>s` (usually `\s`)
