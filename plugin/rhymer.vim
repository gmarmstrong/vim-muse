" See `:help complete-funcitons`
" See `:help complete()`
" See `:help getchar()`

" Returns the visual selection
function GetSelectedText()
    normal gv"xy
    let result = getreg("x")
    normal gv
    return result
endfunction

function RhymeBot()

    " Get rhymes for the visual selection
    let $RHYMING_WORD = GetSelectedText()   "Store rhyming word in an environment variable
    let rhymes = split(system(pyfile "$HOME/.local/lib/datamuse.py"))    "Get a list of rhymes

    " Print list of rhymes
    echo 'Rhymes:'
    let i = 0
    for rhyme in rhymes
        echom i . '.' rhyme
        let i += 1
    endfor

    " Receive user input/choice
    let choice = nr2char(getchar())

    " Echo back user's choice
    " TODO Insert choice instead
    echo rhymes[choice]

endfunction

if !filereadable("$HOME/.local/lib/datamuse.py")
    system("wget https://raw.githubusercontent.com/gmarmstrong/rhymer/master/lib/datamuse.py")
endif

" Map RhymeBot to <leader>r (usually \r)
noremap <leader>r :call RhymeBot()<CR>