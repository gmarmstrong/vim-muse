" Get path of this file's parent directory
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Installs nltk and cmudict if not already installed
function! rhymer#Install()
    execute "!" . s:path . "/../setup.sh"
endfunction

" Returns the visual selection
function! rhymer#GetSelectedText()
    normal! "xy
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

" Returns the previous word
function! rhymer#GetPrevWord()
    normal! geBve
    let s:selectedtext = rhymer#GetSelectedText()
    normal! E
    return s:selectedtext
endfunction

" Returns the result of a datamuse query
function! rhymer#DatamuseWordGetter(query)
    " let s:baseword = expand("<cword>")
    let s:baseword = rhymer#GetPrevWord()
    let s:newwords = split(system("python3 " . s:path . "/../lib/datamuse_interface.py " . a:query . " " . s:baseword))
    return s:newwords
endfunction

" Datamuse Omnifunc completion
function! rhymer#DatamuseWordCompletion(findstart, base)
    if a:findstart == 1
        return col('.')-strlen(expand('<cword>'))
    elseif a:findstart == 0
        return rhymer#DatamuseWordGetter("rel_bga")
    endif
endfunction

" Rhymes with the last word of the previous line
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
    let s:syllable_count = system("python3 $VIMDOTDIR/plugged/rhymer/lib/nsyl/nsyl.py \"" . s:current_line . "\"")
    echo 'Syllables: ' . s:syllable_count
endfunction

" Commands
command! -buffer RhymerML       call rhymer#DatamuseWordBot("ml")
command! -buffer RhymerSL       call rhymer#DatamuseWordBot("sl")
command! -buffer RhymerSP       call rhymer#DatamuseWordBot("sp")
command! -buffer RhymerRelJJA   call rhymer#DatamuseWordBot("rel_jja")
command! -buffer RhymerRelJJB   call rhymer#DatamuseWordBot("rel_jjb")
command! -buffer RhymerRelSYN   call rhymer#DatamuseWordBot("rel_syn")
command! -buffer RhymerRelTRG   call rhymer#DatamuseWordBot("rel_trg")
command! -buffer RhymerRelANT   call rhymer#DatamuseWordBot("rel_ant")
command! -buffer RhymerRelSPC   call rhymer#DatamuseWordBot("rel_spc")
command! -buffer RhymerRelGEN   call rhymer#DatamuseWordBot("rel_gen")
command! -buffer RhymerRelCOM   call rhymer#DatamuseWordBot("rel_com")
command! -buffer RhymerRelPAR   call rhymer#DatamuseWordBot("rel_par")
command! -buffer RhymerRelBGA   call rhymer#DatamuseWordBot("rel_bga")
command! -buffer RhymerRelBGB   call rhymer#DatamuseWordBot("rel_bgb")
command! -buffer RhymerRelRHY   call rhymer#RhymeBot("rel_rhy")
command! -buffer RhymerRelNRHY  call rhymer#RhymeBot("rel_nry")
command! -buffer RhymerRelHOM   call rhymer#DatamuseWordBot("rel_hom")
command! -buffer RhymerRelCNS   call rhymer#DatamuseWordBot("rel_cns")
command! -buffer RhymerNSyl     call rhymer#SyllableCount()

" Define mappings
nnoremap <buffer> <unique> <Plug>(rhymer_ml)        :call rhymer#DatamuseWordBot("ml")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_sl)        :call rhymer#DatamuseWordBot("sl")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_sp)        :call rhymer#DatamuseWordBot("sp")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_jja)   :call rhymer#DatamuseWordBot("rel_jja")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_jjb)   :call rhymer#DatamuseWordBot("rel_jjb")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_syn)   :call rhymer#DatamuseWordBot("rel_syn")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_trg)   :call rhymer#DatamuseWordBot("rel_trg")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_ant)   :call rhymer#DatamuseWordBot("rel_ant")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_spc)   :call rhymer#DatamuseWordBot("rel_spc")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_gen)   :call rhymer#DatamuseWordBot("rel_gen")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_com)   :call rhymer#DatamuseWordBot("rel_com")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_par)   :call rhymer#DatamuseWordBot("rel_par")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_bga)   :call rhymer#DatamuseWordBot("rel_bga")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_bgb)   :call rhymer#DatamuseWordBot("rel_bgb")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_rhy)   :call rhymer#RhymeBot("rel_rhy")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_nry)   :call rhymer#RhymeBot("rel_nry")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_hom)   :call rhymer#DatamuseWordBot("rel_hom")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_rel_cns)   :call rhymer#DatamuseWordBot("rel_cns")<CR>
nnoremap <buffer> <unique> <Plug>(rhymer_nsyl)      :call rhymer#SyllableCount()<CR>

" Initialize default mappings
nmap <Leader>ml    <Plug>(rhymer_ml)
nmap <Leader>sl    <Plug>(rhymer_sl)
nmap <Leader>sp    <Plug>(rhymer_sp)
nmap <Leader>jja   <Plug>(rhymer_rel_jja)
nmap <Leader>jjb   <Plug>(rhymer_rel_jjb)
nmap <Leader>syn   <Plug>(rhymer_rel_syn)
nmap <Leader>trg   <Plug>(rhymer_rel_trg)
nmap <Leader>ant   <Plug>(rhymer_rel_ant)
nmap <Leader>spc   <Plug>(rhymer_rel_spc)
nmap <Leader>gen   <Plug>(rhymer_rel_gen)
nmap <Leader>com   <Plug>(rhymer_rel_com)
nmap <Leader>par   <Plug>(rhymer_rel_par)
nmap <Leader>bga   <Plug>(rhymer_rel_bga)
nmap <Leader>bgb   <Plug>(rhymer_rel_bgb)
nmap <Leader>rhy   <Plug>(rhymer_rel_rhy)
nmap <Leader>nry   <Plug>(rhymer_rel_nry)
nmap <Leader>hom   <Plug>(rhymer_rel_hom)
nmap <Leader>cns   <Plug>(rhymer_rel_cns)
nmap <Leader>nsyl  <Plug>(rhymer_nsyl)

" Enable  auto-completion
setlocal completefunc=rhymer#DatamuseWordCompletion
