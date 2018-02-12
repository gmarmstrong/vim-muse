# `rhymer`

The `rhymer` plugin is a rhyming assistant for the Vim text editor. It was
written for [UGAHacks](http://ugahacks.com/) 2018.

## Example

![Demo recording of rhymer](https://i.imgur.com/5ORa10L.gif)

## Installation

`rhymer` should work with any plugin manager, but only `vim-plug` is currently
tested or documented here.

1. Install [`vim-plug`](https://github.com/junegunn/vim-plug)
2. Add `Plug 'gmarmstrong/rhymer'` to the `plug` call in your `~/.vimrc`.
3. Restart Vim
4. Enter `:PlugInstall`

### Further installation

* Use `:call rhymer#InstallNLTK()` to add syllable support
* Use `:PlugUpdate` to update to the latest release

## Usage

### Rhyming with the previous line (AA/BB)

1. Put the cursor below the line with which you want to rhyme
2. Hit `<leader>r` (usually `\r`)
3. Select a rhyming word

### Replace a word with a synonym

1. Put the cursor over the word which you want to replace
2. Hit `<leader>m` (usually `\m`)
3. Select a synonym

### Syllable counting

1. Put the cursor on the line of which to count the syllables
2. Hit `<leader>s` (usually `\s`)
