" Get path of this file's parent directory
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Installs nltk and cmudict if not already installed
function! muse#Install()
    execute "!" . s:path . "/../scripts/setup.sh"
endfunction

" Installs nltk and cmudict if not already installed
function! muse#Update()
    execute "!" . s:path . "/../scripts/update.sh"
endfunction

" Returns the visual selection
function! muse#GetSelectedText()
    try
        let x_prev = @x
        normal "xy
        return @x
    finally
        let @a = x_prev
    endtry
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

" Interacts with datamuse_interface.py
" param query:      Datamuse API function
" param basetext:   Text on which to operate
function! muse#Datamuse(query, basetext)
    let s:datamuse_interface = "python3 \"" . s:path . "/../lib/datamuse_interface.py\""
    return split(system(s:datamuse_interface . " " . a:query . " \"" . s:baseword . "\""))
endfunction

" Replaces current text with new word
" param query:      Datamuse API function
" param choice:     'user' or an integer
function! muse#DatamusePop(query, choice)
    let s:newwords = muse#Datamuse(a:query, s:baseword)
    if len(s:newwords) == 0                         " If no Datamuse results
        echo "No results."
        return
    elseif expand(a:choice) == "user"               " If choice is 'user'
        let s:newword = muse#ListWords(s:newwords)
    elseif type(a:choice) == type(0)                " If choice is number
        let s:newword = s:newwords[a:choice]
    else
        echo "ERROR: Invalid choice"
        return
    endif
    call muse#ReplaceCurrentText(s:newword)
endfunction

function! muse#DatamusePrevWord(query)
    let s:baseword = muse#GetPrevWord()
    let s:newwords = muse#Datamuse(a:query, s:baseword)
    return s:newwords
endfunction

" Datamuse Omnifunc completion
function! muse#DatamuseWordFollow(findstart, base)
    if a:findstart == 1
        return col('.')-strlen(expand('<cword>'))
    elseif a:findstart == 0
        return muse#DatamusePrevWord("rel_bga")
    endif
endfunction

" Rhymes with the last word of the previous line
" FIXME
function! muse#RhymeBot(query)
    " Get rhymes for the previous text
    let s:rhyming_word = muse#GetPrevText()

    " Get new words
    let s:rhymes = split(system("python3 " . s:path . "/../lib/datamuse_interface.py " . a:query . " " . s:rhyming_word))

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

" Print list of words and return user's choice
function! muse#ListWords(newwords)
    let s:count = 0
    for s:newword in a:newwords
        echom s:count . '. ' . s:newword
        let s:count += 1
    endfor
    return a:newwords[nr2char(getchar())]
endfunction

" Replace current word with new word,
function! muse#ReplaceCurrentText(newword)
    let @q = s:newword
    if mode() == 'v' || mode() == 'V' || mode() == 'CTRL-V'
        normal! "qp
    else
        normal! viw"qp
    endif
endfunction

" Echoes the number of syllables in the line
function! muse#SyllableCount() abort
    echo 'Counting syllables...'
    normal "syy
    let s:current_line = getreg("s")
    let s:syllable_count = system("python3 \"" . s:path . "\"/..lib/datamuse_interface.py\" \"" . s:current_line . "\"")
    echo 'Syllables: ' . s:syllable_count
endfunction

" Commands
command! -buffer MuseInstall    call muse#Install()
command! -buffer MuseUpdate     call muse#Update()
command! -buffer MuseML         call muse#DatamusePop("ml","user")
command! -buffer MuseSL         call muse#DatamusePop("sl","user")
command! -buffer MuseSP         call muse#DatamusePop("sp","user")
command! -buffer MuseRelJJA     call muse#DatamusePop("rel_jja","user")
command! -buffer MuseRelJJB     call muse#DatamusePop("rel_jjb","user")
command! -buffer MuseRelSYN     call muse#DatamusePop("rel_syn","user")
command! -buffer MuseRelTRG     call muse#DatamusePop("rel_trg","user")
command! -buffer MuseRelANT     call muse#DatamusePop("rel_ant","user")
command! -buffer MuseRelSPC     call muse#DatamusePop("rel_spc","user")
command! -buffer MuseRelGEN     call muse#DatamusePop("rel_gen","user")
command! -buffer MuseRelCOM     call muse#DatamusePop("rel_com","user")
command! -buffer MuseRelPAR     call muse#DatamusePop("rel_par","user")
command! -buffer MuseRelBGA     call muse#DatamusePop("rel_bga","user")
command! -buffer MuseRelBGB     call muse#DatamusePop("rel_bgb","user")
command! -buffer MuseRelRHY     call muse#RhymeBot("rel_rhy","user")
command! -buffer MuseRelNRHY    call muse#RhymeBot("rel_nry","user")
command! -buffer MuseRelHOM     call muse#DatamusePop("rel_hom","user")
command! -buffer MuseRelCNS     call muse#DatamusePop("rel_cns","user")
command! -buffer MuseNSYL       call muse#SyllableCount()

" Define mappings
nnoremap <buffer> <unique> <Plug>(muse_ml)      :call muse#DatamusePop("ml","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_sl)      :call muse#DatamusePop("sl","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_sp)      :call muse#DatamusePop("sp","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_jja) :call muse#DatamusePop("rel_jja","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_jjb) :call muse#DatamusePop("rel_jjb","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_syn) :call muse#DatamusePop("rel_syn","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_trg) :call muse#DatamusePop("rel_trg","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_ant) :call muse#DatamusePop("rel_ant","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_spc) :call muse#DatamusePop("rel_spc","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_gen) :call muse#DatamusePop("rel_gen","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_com) :call muse#DatamusePop("rel_com","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_par) :call muse#DatamusePop("rel_par","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_bga) :call muse#DatamusePop("rel_bga","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_bgb) :call muse#DatamusePop("rel_bgb","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_rhy) :call muse#RhymeBot("rel_rhy","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_nry) :call muse#RhymeBot("rel_nry","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_hom) :call muse#DatamusePop("rel_hom","user")<CR>
nnoremap <buffer> <unique> <Plug>(muse_rel_cns) :call muse#DatamusePop("rel_cns","user")<CR>
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

" Word suggestions
setlocal omnifunc=muse#DatamuseWordFollow
