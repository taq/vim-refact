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
             let s:outside_pattern = '\%(def\|class\|module\) '
             let s:inside_pattern  = '\%(def\|class\|module\|while\|for\) ' 
             let s:end_pattern     = 'end'
             let s:method          = "def"
             let s:cls             = '\%(class\|module\)'
augroup END

function! s:VimRefactGetScope()
   let l:ppos = searchpairpos(s:outside_pattern,'',s:end_pattern,"bW")
   let l:npos = searchpairpos(s:inside_pattern ,'',s:end_pattern,"W")
   let l:type = substitute(matchlist(getbufline("%",l:ppos[0])[0],s:outside_pattern)[0]," ","","")
   return [l:ppos,l:npos,l:type]
endfunction

function! s:VimRefactExtractMethod(...) range
   let l:mode = visualmode()
   if l:mode != "V"
      return
   endif

   " get some info
   let l:scope = s:VimRefactGetScope()
   let l:block = l:scope[2]
   let l:size  = l:scope[1][0]-l:scope[0][0]
   let l:argx  = ""
   let l:imeth = l:block =~ s:method

   " lets check if there are arguments
   if(a:[0]>1)
      let l:argl = []
      for l:argi in range(a:[0]-1)
         call add(l:argl,a:000[l:argi+1])
      endfor         
      let l:argx = "(".join(l:argl,",").")"
   endif

   " yank and create a new method
   execute a:firstline.",".a:lastline."y"
   call append(l:scope[1][0]+(l:imeth ? 0 : -2),s:method." ".a:1.l:argx)
   call append(l:scope[1][0]+(l:imeth ? 1 : -2),s:end_pattern)

   " put the yanked content
   execute l:scope[1][0]+(l:imeth ? 1 : 0)."put"

   " delete the selection and call the new method there, if needed
   execute a:firstline.",".a:lastline."d"
   if(l:imeth)
      call append(a:firstline-1,a:1.l:argx)
   endif      
   call feedkeys("\<CR>","t")

   " indent the block
   execute ":".l:scope[0][0]
   call feedkeys("\<S-v>")
   call feedkeys(((l:size*2)-1)."j")
   call feedkeys("=","t")
endfunction

function! s:VimRefactRenameVariable(...)
   let l:scope = s:VimRefactGetScope()
   execute l:scope[0][0].",".l:scope[1][0]."s/".a:[1]."/".a:[2]."/g"
endfunction

command! -range -nargs=+ Rem :<line1>,<line2>call <SID>VimRefactExtractMethod(<f-args>)
command! -nargs=+ Rmv :call <SID>VimRefactRenameVariable(<f-args>)
