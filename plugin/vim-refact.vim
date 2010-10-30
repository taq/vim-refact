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
   return [l:ppos,l:npos]
endfunction

function! s:VimRefactBlockType()
   let l:scope = s:VimRefactGetScope()
   return matchlist(getbufline("%",l:scope[0][0])[0],'\%(def\|class\|module\)')[0]
endfunction

function! s:VimRefactExtractMethod()
   echo "bla"
endfunction

function! TestRefact()
   echo s:VimRefactBlockType()
endfunction

vnoremap rem <SID>:VimRefactExtractMethod<CR>
