" Vim refactoring plugin
" Last change: 2010-10-29
" Version 0.0.1
" Maintainer: Eustaquio 'TaQ' Rangel
" License: GPL
" URL: git://github.com/taq/vim-refact.git
"

function! s:VimRefactEndPos()
   let l:ppos  = searchpairpos("def","","end","b")
   let l:npos  = searchpairpos("def","","end")
endfunction
