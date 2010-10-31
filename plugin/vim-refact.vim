" Vim refactoring plugin
" Last change: 2010-10-29
" Version 0.0.1
" Maintainer: Eustaquio 'TaQ' Rangel
" License: GPL
" URL: git://github.com/taq/vim-refact.git
"

augroup vimrefact
   au!
   autocmd FileType ruby
   let s:begin_pattern  = '\%(def\|class\|module\) '
   let s:end_pattern    = 'end'
augroup END

function! s:VimRefactGetScope()
   let l:ppos = searchpairpos(s:begin_pattern,'',s:end_pattern,"bWn")
   let l:npos = searchpairpos(s:begin_pattern,'',s:end_pattern,"Wn")
   let l:type = substitute(matchlist(getbufline("%",l:ppos[0])[0],s:begin_pattern)[0]," ","","")
   return [l:ppos,l:npos,l:type]
endfunction

function! s:VimRefactExtractMethod()
   echo "bla"
endfunction

function! TestRefact()
   echo s:VimRefactGetScope()
endfunction

vnoremap rem <SID>:VimRefactExtractMethod<CR>
