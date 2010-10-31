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

function! VimRefactExtractMethod(name) range
   let l:mode = visualmode()
   if l:mode != "V"
      return
   endif
   let l:scope = s:VimRefactGetScope()
   let l:block = l:scope[2]
   execute a:firstline.",".a:lastline."y"
   call append(l:scope[1][0],l:block." ".a:name)
   call append(l:scope[1][0]+1,"end")
   execute l:scope[1][0]+1."put"
   execute a:firstline.",".a:lastline."d"
   call append(l:scope[0][0],a:name)
endfunction

function! TestRefact()
   echo s:VimRefactGetScope()
endfunction

command! -range -nargs=+ Em :<line1>,<line2>call VimRefactExtractMethod(<q-args>)
