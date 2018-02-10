## Settling on a project

We had a few other ideas before we settled on a Neovim plugin with the [datamuse API](http://www.datamuse.com/api/). For example, matching up the first 100 or so most frequent English words with single (alphabetic) key text expansion based on quantitative statistics (t --> the, or t --> that, depending on what would save more keystrokes overall). However, we quickly realized that at our present skill level, handling anything too large over the course of the event would simply lead to us not accomplishing anything fully. So we decided to keep it smaller and focus instead on making sure it, you know, actually worked.

Developing a plugin for Neovim was the obvious choice. Two of us use Emacs (a la Spacemacs), and the other uses Vim 8. However, none of us are well versed in Emacs Lisp or Vim Script, and getting up to speed on the necessary components (handling calls for a web API, e.g.) seemed unrealistic, especially since these things are not as seamless as in languages like Python.

So we decided to develop a plugin using Python. We're a bit rusty (since all our recent coursework has been Java), but we figured it has good/intuitive package support and clean syntax, so it would be easy to pick up what we needed with Google-fu. Python is also one of the preferred languages for writing plugins for Neovim, which has [a client](https://github.com/neovim/python-client) for it.

## Basic idea and purpose

The general concept behind our idea is pretty simple: to create a Neovim plugin that lets you bind a key (or chord/sequence) to a function that lets you choose a list of words that rhyme with the last word on the previous line.

Here's a brief outline of the steps required after the plugin is activated:

1. Get the last word on the previous line by capturing the line, splitting on whitespace, and grabbing the last index in the return list
2. Use regex substitution to get rid of characters not in the set [A-Za-z\\-'] (to get just the word, less punctuation and so forth).
3. Send the word to the datamuse API, asking for a list of words that rhyme
4. Use the returned JSON to generate a list of rhyming words. 
5. Filter non-hyphenated multi-word matches out of the list of words (e.g., if we are rhyming with "power", "Dwight D. Eisenhower" would get eliminated in this step)
6. Send the first 10 matches to the :ex line at the bottom of the screen, and allow the user to pick one of the 10 options by pressing 0-9 (the digits)
7. Insert the chosen option at the position that the text-entry cursor was located at the time of the initial plugin call, and return focus to that frame.



