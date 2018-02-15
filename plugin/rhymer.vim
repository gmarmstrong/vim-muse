" Get path of this file's parent directory
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Installs nltk and cmudict if not already installed
function! rhymer#Install()
    execute "!" . s:path . "/../setup.sh"
endfunction

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

function! rhymer#RhymeBot(query)
    " Get rhymes for the previous text
    let s:rhyming_word = rhymer#GetPrevText()

    " Get new words
    let s:rhymes = split(system("python3 " . s:path . "/../lib/datamuse_interface.py " . a:query ." " . s:rhyming_word))

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

function! rhymer#DatamuseWordBot(query)
    " Get the word under the cursor
    let s:baseword = expand("<cword>")

    " Get new words
    let s:newwords = split(system("python3 " . s:path . "/../lib/datamuse_interface.py " . a:query . " " . s:baseword))

    " Print list of new words
    let s:count = 0
    for s:newword in s:newwords
        echom s:count . '.' s:newword
        let s:count += 1
    endfor

    " Receive user input/choice
    let @q = s:newwords[nr2char(getchar())]

    " Replace current word with new word
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

" TODO Allow insert mode
" Define mappings
noremap <unique> <Plug>rhymer-ml :call rhymer#DatamuseWordBot("ml")<CR>
noremap <unique> <Plug>rhymer-sl :call rhymer#DatamuseWordBot("sl")<CR>
noremap <unique> <Plug>rhymer-sp :call rhymer#DatamuseWordBot("sp")<CR>
noremap <unique> <Plug>rhymer-rel_jja :call rhymer#DatamuseWordBot("rel_jja")<CR>
noremap <unique> <Plug>rhymer-rel_jjb :call rhymer#DatamuseWordBot("rel_jjb")<CR>
noremap <unique> <Plug>rhymer-rel_syn :call rhymer#DatamuseWordBot("rel_syn")<CR>
noremap <unique> <Plug>rhymer-rel_trg :call rhymer#DatamuseWordBot("rel_trg")<CR>
noremap <unique> <Plug>rhymer-rel_ant :call rhymer#DatamuseWordBot("rel_ant")<CR>
noremap <unique> <Plug>rhymer-rel_spc :call rhymer#DatamuseWordBot("rel_spc")<CR>
noremap <unique> <Plug>rhymer-rel_gen :call rhymer#DatamuseWordBot("rel_gen")<CR>
noremap <unique> <Plug>rhymer-rel_com :call rhymer#DatamuseWordBot("rel_com")<CR>
noremap <unique> <Plug>rhymer-rel_par :call rhymer#DatamuseWordBot("rel_par")<CR>
noremap <unique> <Plug>rhymer-rel_bga :call rhymer#DatamuseWordBot("rel_bga")<CR>
noremap <unique> <Plug>rhymer-rel_bgb :call rhymer#DatamuseWordBot("rel_bgb")<CR>
noremap <unique> <Plug>rhymer-rel_rhy :call rhymer#RhymeBot("rel_rhy")<CR>
noremap <unique> <Plug>rhymer-rel_nrhy :call rhymer#RhymeBot("rel_nry")<CR>
noremap <unique> <Plug>rhymer-rel_hom :call rhymer#DatamuseWordBot("rel_hom")<CR>
noremap <unique> <Plug>rhymer-rel_cns :call rhymer#DatamuseWordBot("rel_cns")<CR>
noremap <leader> <Plug>rhymer-nsyl :call rhymer#SyllableCount()<CR>

" Initialize default mappings
nmap <localleader>ml <Plug>rhymer-ml
nmap <localleader>sl <Plug>rhymer-sl
nmap <localleader>sp <Plug>rhymer-sp
nmap <localleader>jja <Plug>rhymer-rel_jja
nmap <localleader>jjb <Plug>rhymer-rel_jjb
nmap <localleader>syn <Plug>rhymer-rel_syn
nmap <localleader>trg <Plug>rhymer-rel_trg
nmap <localleader>ant <Plug>rhymer-rel_ant
nmap <localleader>spc <Plug>rhymer-rel_spc
nmap <localleader>gen <Plug>rhymer-rel_gen
nmap <localleader>com <Plug>rhymer-rel_com
nmap <localleader>par <Plug>rhymer-rel_par
nmap <localleader>bga <Plug>rhymer-rel_bga
nmap <localleader>bgb <Plug>rhymer-rel_bgb
nmap <localleader>rhy <Plug>rhymer-rel_rhy
nmap <localleader>nrhy <Plug>rhymer-rel_nrhy
nmap <localleader>hom <Plug>rhymer-rel_hom
nmap <localleader>cns <Plug>rhymer-rel_cns
nmap <localleader>nsyl <Plug>rhymer-nsyl
