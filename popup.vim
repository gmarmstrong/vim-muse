" See `:help complete-funcitons`
" See `:help complete()`
" See `:help getchar()`

echohl 'RhymeBot'
echo 'Rhymes:'
echohl None
echo '1. foo'
echo '2. bar'
let choice = nr2char(getchar())
if choice == 1
    echo 'FOO'
elseif choice == 2
    echo 'BAR'
endif