" Vim global plugin for suggesting rhymes

" TODO Utilize lib/syl_interface.py (for 'line numbers')

" Returns the visual selection
function! rhymer#GetSelectedText()
    normal "xy
    let s:result = getreg("x")
    return s:result
endfunction

" Returns the last word of the previous line
function! rhymer#GetPrevText()
    normal! k$Bve
    let s:selectedtext = rhymer#GetSelectedText()
    normal! j$
    return s:selectedtext
endfunction

function! rhymer#RhymeBot()

    " Get rhymes for the visual selection
    let s:rhyming_word = rhymer#GetPrevText()
    let s:rhymes = split(system("python3 $VIMDOTDIR/plugged/rhymer/lib/dm_interface.py " . s:rhyming_word))

    " Print list of rhymes
    echo 'Rhymes with ' . s:rhyming_word . ':'
    let s:count = 0
    for s:rhyme in s:rhymes
        echom s:count . '.' s:rhyme
        let s:count += 1
    endfor

    " Receive user input/choice
    " See `:help complete-funcitons`
    " See `:help complete()`
    " See `:help getchar()`
    let @q = s:rhymes[nr2char(getchar())]

    " Insert choice
    normal! "qp
    startinsert!

endfunction

" Map RhymeBot to <leader>r (usually \r)
noremap <leader>r :call rhymer#RhymeBot()<CR>

" Use RhymeBot in insert mode
inoremap <leader>r <C-o>:call rhymer#RhymeBot()<CR>
