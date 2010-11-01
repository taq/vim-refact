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
   let s:begin_pattern  = '\%(def\|class\|module\|while\|for\) '
   let s:end_pattern    = 'end'
augroup END

function! s:VimRefactGetScope()
   let l:ppos = searchpairpos(s:begin_pattern,'',s:end_pattern,"bWn")
   let l:npos = searchpairpos(s:begin_pattern,'',s:end_pattern,"Wn")
   let l:type = substitute(matchlist(getbufline("%",l:ppos[0])[0],s:begin_pattern)[0]," ","","")
   return [l:ppos,l:npos,l:type]
endfunction

function! VimRefactExtractMethod(...) range
   let l:mode = visualmode()
   if l:mode != "V"
      return
   endif

   " get some info
   let l:scope = s:VimRefactGetScope()
   let l:block = l:scope[2]
   let l:size  = l:scope[1][0]-l:scope[0][0]
   let l:argx  = ""

   " lets check if there are arguments
   if(a:[0]>1)
      let l:argl = []
      for l:argi in range(a:[0])
         call add(l:argl,a:000[l:argi+1])
      endfor         
      let l:argx = "(".join(l:argl,",").")"
   endif

   " yank and create a new method
   execute a:firstline.",".a:lastline."y"
   call append(l:scope[1][0],l:block." ".a:1.l:argx)
   call append(l:scope[1][0]+1,"end")

   " put the yanked content
   execute l:scope[1][0]+1."put"

   " delete the selection and call the new method there
   execute a:firstline.",".a:lastline."d"
   call append(l:scope[0][0],a:1.l:argx)
   call feedkeys("\<CR>","t")

   " indent the block
   execute ":".l:scope[0][0]
   call feedkeys("\<S-v>")
   call feedkeys(((l:size*2)-1)."j")
   call feedkeys("=","t")
endfunction

function! TestRefact()
   echo s:VimRefactGetScope()
endfunction

command! -range -nargs=+ Rem :<line1>,<line2>call VimRefactExtractMethod(<f-args>)
