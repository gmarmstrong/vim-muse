" Get path of this file's parent directory
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Installs nltk and cmudict if not already installed
function! muse#Install()
    execute "!" . s:path . "/../setup.sh"
endfunction

" Returns the visual selection
function! muse#GetSelectedText()
    normal! "xy
    let s:result = getreg("x")
    return s:result
endfunction

" Returns the last word of the previous line
function! muse#GetPrevText()
    normal! k$Bve
    let s:selectedtext = muse#GetSelectedText()
    normal! j$
    return s:selectedtext
endfunction

" Returns the previous word
function! muse#GetPrevWord()
    normal! geBve
    let s:selectedtext = muse#GetSelectedText()
    normal! E
    return s:selectedtext
endfunction

" Returns the result of a datamuse query
function! muse#DatamuseWordGetter(query)
    " let s:baseword = expand("<cword>")
    let s:baseword = muse#GetPrevWord()
    let s:newwords = split(system("python3 " . s:path . "/../lib/datamuse_interface.py " . a:query . " " . s:baseword))
    return s:newwords
endfunction

" Datamuse Omnifunc completion
function! muse#DatamuseWordCompletion(findstart, base)
    if a:findstart == 1
        return col('.')-strlen(expand('<cword>'))
    elseif a:findstart == 0
        return muse#DatamuseWordGetter("rel_bga")
    endif
endfunction

" Rhymes with the last word of the previous line
function! muse#RhymeBot(query)
    " Get rhymes for the previous text
    let s:rhyming_word = muse#GetPrevText()

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

function! muse#DatamuseWordBot(query)
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

function! muse#SyllableCount()
    echo 'Counting syllables...'
    normal "syy
    let s:current_line = getreg("s")
    let s:syllable_count = system("python3 $VIMDOTDIR/plugged/muse/lib/nsyl/nsyl.py \"" . s:current_line . "\"")
    echo 'Syllables: ' . s:syllable_count
endfunction

" Commands
command! -buffer RhymerML       call muse#DatamuseWordBot("ml")
command! -buffer RhymerSL       call muse#DatamuseWordBot("sl")
command! -buffer RhymerSP       call muse#DatamuseWordBot("sp")
command! -buffer RhymerRelJJA   call muse#DatamuseWordBot("rel_jja")
command! -buffer RhymerRelJJB   call muse#DatamuseWordBot("rel_jjb")
command! -buffer RhymerRelSYN   call muse#DatamuseWordBot("rel_syn")
command! -buffer RhymerRelTRG   call muse#DatamuseWordBot("rel_trg")
command! -buffer RhymerRelANT   call muse#DatamuseWordBot("rel_ant")
command! -buffer RhymerRelSPC   call muse#DatamuseWordBot("rel_spc")
command! -buffer RhymerRelGEN   call muse#DatamuseWordBot("rel_gen")
command! -buffer RhymerRelCOM   call muse#DatamuseWordBot("rel_com")
command! -buffer RhymerRelPAR   call muse#DatamuseWordBot("rel_par")
command! -buffer RhymerRelBGA   call muse#DatamuseWordBot("rel_bga")
command! -buffer RhymerRelBGB   call muse#DatamuseWordBot("rel_bgb")
command! -buffer RhymerRelRHY   call muse#RhymeBot("rel_rhy")
command! -buffer RhymerRelNRHY  call muse#RhymeBot("rel_nry")
command! -buffer RhymerRelHOM   call muse#DatamuseWordBot("rel_hom")
command! -buffer RhymerRelCNS   call muse#DatamuseWordBot("rel_cns")
command! -buffer RhymerNSyl     call muse#SyllableCount()

" Define mappings
nnoremap <buffer> <unique> <Plug>(muse_ml)      :call muse#DatamuseWordBot("ml")<CR>
nnoremap <buffer> <unique> <Plug>(muse_sl)      :call muse#DatamuseWordBot("sl")<CR>
nnoremap <buffer> <unique> <Plug>(muse_sp)      :call muse#DatamuseWordBot("sp")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_jja) :call muse#DatamuseWordBot("rel_jja")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_jjb) :call muse#DatamuseWordBot("rel_jjb")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_syn) :call muse#DatamuseWordBot("rel_syn")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_trg) :call muse#DatamuseWordBot("rel_trg")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_ant) :call muse#DatamuseWordBot("rel_ant")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_spc) :call muse#DatamuseWordBot("rel_spc")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_gen) :call muse#DatamuseWordBot("rel_gen")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_com) :call muse#DatamuseWordBot("rel_com")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_par) :call muse#DatamuseWordBot("rel_par")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_bga) :call muse#DatamuseWordBot("rel_bga")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_bgb) :call muse#DatamuseWordBot("rel_bgb")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_rhy) :call muse#RhymeBot("rel_rhy")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_nry) :call muse#RhymeBot("rel_nry")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_hom) :call muse#DatamuseWordBot("rel_hom")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_cns) :call muse#DatamuseWordBot("rel_cns")<CR>
nnoremap <buffer> <unique> <Plug>(muse_nsyl)    :call muse#SyllableCount()<CR>

" Initialize default mappings
nmap <Leader>ml    <Plug>(muse_ml)
nmap <Leader>sl    <Plug>(muse_sl)
nmap <Leader>sp    <Plug>(muse_sp)
nmap <Leader>jja   <Plug>(muse_rel_jja)
nmap <Leader>jjb   <Plug>(muse_rel_jjb)
nmap <Leader>syn   <Plug>(muse_rel_syn)
nmap <Leader>trg   <Plug>(muse_rel_trg)
nmap <Leader>ant   <Plug>(muse_rel_ant)
nmap <Leader>spc   <Plug>(muse_rel_spc)
nmap <Leader>gen   <Plug>(muse_rel_gen)
nmap <Leader>com   <Plug>(muse_rel_com)
nmap <Leader>par   <Plug>(muse_rel_par)
nmap <Leader>bga   <Plug>(muse_rel_bga)
nmap <Leader>bgb   <Plug>(muse_rel_bgb)
nmap <Leader>rhy   <Plug>(muse_rel_rhy)
nmap <Leader>nry   <Plug>(muse_rel_nry)
nmap <Leader>hom   <Plug>(muse_rel_hom)
nmap <Leader>cns   <Plug>(muse_rel_cns)
nmap <Leader>nsyl  <Plug>(muse_nsyl)

" Enable  auto-completion
setlocal omnifunc=muse#DatamuseWordCompletion
