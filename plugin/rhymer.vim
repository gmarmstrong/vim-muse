" Get path of this file's parent directory
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Installs nltk and cmudict if not already installed
function! rhymer#Install()
    execute "!" . s:path . "/../setup.sh"
endfunction

" Returns the visual selection
function! rhymer#GetSelectedText()
    " TODO Consider "xyiw
    normal "xy
    let s:result = getreg("x")
    return s:result
endfunction

" Returns the current word
function! rhymer#GetCurrentWord()
    return expand("<cword>")
endfunction

" Returns the last word of the previous line
function! rhymer#GetPrevText()
    normal! k$Bve
    let s:selectedtext = rhymer#GetSelectedText()
    normal! j$
    return s:selectedtext
endfunction

function! rhymer#RhymeBot()

    " Get rhymes for the previous text
    let s:rhyming_word = rhymer#GetPrevText()
    let s:rhymes = split(system("python3 " . s:path . "/../lib/datamuse_interface.py rel_rhy " . s:rhyming_word))

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

endfunction

function! rhymer#SynonymBot()

    " Get synonyms for the current word.
    let s:synonym_word = rhymer#GetCurrentWord()
    let s:synonyms = split(system("python3 " . s:path . "/../lib/datamuse_interface.py ml " . s:synonym_word))

    " Print list of synonyms
    echo 'Synonyms of ' . s:synonym_word . ':'
    let s:count = 0
    for s:synonym in s:synonyms
        echom s:count . '.' s:synonym
        let s:count += 1
    endfor

    " Receive user input/choice
    let @q = s:synonyms[nr2char(getchar())]

    " Replace word with synonym
    normal diw
    let prevchar = getline('.')[col('.')-1]
    let currchar = getline('.')[col('.')]
    let nextchar = getline('.')[col('.')+1]
    if col('.')+1 == col('$') && col('.')+1 != 1    " If end of line
        normal "qp
    elseif currchar != " "                          " If middle of line
        normal "qP
    else
        if prevchar == " "                          " If punctuation
            normal "qP
        else                                        " If beginning of line
            normal "qp
        endif
    endif

endfunction

function! rhymer#SyllableCount()
    echo 'Counting syllables...'
    normal "syy
    let s:current_line = getreg("s")
    let s:syllable_count = system("python3 $VIMDOTDIR/plugged/rhymer/lib/syl_interface.py \"" . s:current_line . "\"")
    echo 'Syllables: ' . s:syllable_count
endfunction

" Map SynonymBot to <leader>m (usually \m)
noremap <leader>m :call rhymer#SynonymBot()<CR>

" Map RhymeBot to <leader>r (usually \r)
noremap <leader>r :call rhymer#RhymeBot()<CR>

" Use RhymeBot in insert mode (also <leader>r)
inoremap <leader>r <C-o>:call rhymer#RhymeBot() \| startinsert! <CR>

" Map SyllableCount to <leader>s (usually \s)
noremap <leader>s :call rhymer#SyllableCount()<CR>
