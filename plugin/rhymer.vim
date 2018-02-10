" See `:help complete-funcitons`
" See `:help complete()`
" See `:help getchar()`

" Returns the visual selection
function GetSelectedText()
    normal "xy
    let result = getreg("x")
    return result
endfunction

" Returns the last word of the previous line
function GetPrevText()
    let save_pos = getpos(".")
    execute "normal! k$Bve"
    let selectedtext = GetSelectedText()
    visual! "<esc>"
    call setpos('.', save_pos)
    return selectedtext
endfunction

function RhymeBot()

    " Get rhymes for the visual selection
    let rhyming_word = GetPrevText()
    let rhymes = split(system("python3 $HOME/.local/lib/dm_interface.py " . rhyming_word))

    " Print list of rhymes
    echo 'Rhymes with ' . rhyming_word . ':'
    let i = 0
    for rhyme in rhymes
        echom i . '.' rhyme
        let i += 1
    endfor

    " Receive user input/choice
    let @q = " " . rhymes[nr2char(getchar())]

    normal! "qp
    startinsert!

endfunction

" Map RhymeBot to <leader>r (usually \r)
noremap <leader>r :call RhymeBot()<CR>

" Use RhymeBot in insert mode
inoremap <leader>r <C-o>:call RhymeBot()<CR>
