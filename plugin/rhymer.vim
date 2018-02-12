" Vim global plugin for suggesting rhymes

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Installs nltk and cmudict if not already installed
function! rhymer#InstallNLTK()
    silent execute "!python3 -c \"import nltk\""
    if v:shell_error
        execute "!pip3 install nltk"
    endif
    silent execute "!python3 -c \"from nltk.corpus import cmudict\""
    if v:shell_error
        execute "!python3 -c \"import nltk; nltk.download('cmudict')\""
    endif
endfunction

" Returns the visual selection
function! rhymer#GetSelectedText()
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
    let s:rhymes = split(system("python3 " . s:path . "/../lib/dm_rhyme_interface.py " . s:rhyming_word))

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

function! rhymer#SynonymBot()

    " Get synonyms for the current word.
    let s:synonym_word = rhymer#GetCurrentWord()
    let s:synonyms = split(system("python3 " . s:path . "/../lib/dm_synonym_interface.py " . s:synonym_word))

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
    echo "Synonym placed in buffer: q"
    "" TODO Replace word with synonym
    "normal diw
    "echo getline('.')[col('.')-1]
    "let prevchar = getline('.')[col('.')-1]
    "let currchar = getline('.')[col('.')]
    "echo prevchar
    "echo currcar
    "if currchar != " "
    "    if prevchar == " "
    "        normal "qP
    "    endif
    "else
    "    if prevchar == " "
    "        normal "qP
    "    else
    "        normal "qp
    "    endif
    "endif

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

" Use RhymeBot in insert mode
inoremap <leader>r <C-o>:call rhymer#RhymeBot()<CR>

" Map SyllableCount to <leader>s (usually \s)
noremap <leader>s :call rhymer#SyllableCount()<CR>
