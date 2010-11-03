" Vim refactoring plugin
" Last change: 2010-10-29
" Version 0.0.1
" Maintainer: Eustaquio 'TaQ' Rangel
" License: GPL
" URL: git://github.com/taq/vim-refact.git
"

let b:outside_pattern = ""
let b:inside_pattern  = ""
let b:start_pattern   = ""
let b:end_pattern     = ""
let b:method_pattern  = ""
let b:method          = ""
let b:cls_pattern     = ""
let b:cls             = ""
let b:attr_prefix     = ""
let b:line_terminator = ""

augroup vimrefact
   au!
   autocmd FileType ruby call s:VimRefactLoadRuby()
   autocmd FileType java call s:VimRefactLoadJava()
augroup END

function! s:VimRefactLoadRuby()
   let b:outside_pattern = '\%(def\|class\|module\) ' 
   let b:inside_pattern  = '\%(def\|class\|module\|while\|for\) ' 
   let b:start_pattern   = ''
   let b:end_pattern     = 'end'
   let b:method_pattern  = 'def'
   let b:method          = 'def'
   let b:cls_pattern     = '\%(class\|def\|while\|for\)' 
   let b:cls             = 'class'
   let b:attr_prefix     = "@"
   let b:line_terminator = ""
endfunction

function! s:VimRefactLoadJava()
   let b:outside_pattern = '{' 
   let b:inside_pattern  = '{' 
   let b:start_pattern   = '{'
   let b:end_pattern     = '}'
   let b:method_pattern  = '.'
   let b:method          = 'public void'
   let b:cls_pattern     = 'class\s\+\w\+\s\?{\?'
   let b:cls             = 'class' 
   let b:attr_prefix     = 'this\.'
   let b:line_terminator = ";"
endfunction

function! s:VimRefactGetScope()
   if strlen(b:outside_pattern)<1
      return
   endif
   let l:ppos = searchpairpos(b:outside_pattern,'',b:end_pattern,"bW")
   let l:npos = searchpairpos(b:inside_pattern ,'',b:end_pattern,"W")
   let l:type = substitute(matchlist(getbufline("%",l:ppos[0])[0],b:outside_pattern)[0]," ","","")
   return [l:ppos,l:npos,l:type]
endfunction

function! s:VimRefactGetClassScope()
   let l:ppos = searchpairpos(b:cls_pattern,'',b:end_pattern,'Wb','getline(".") !~ "".b:cls.""')
   let l:npos = searchpairpos(b:cls_pattern,'',b:end_pattern,'W')
   return [l:ppos,l:npos]
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
   let l:imeth = l:block =~ b:method_pattern

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
   call append(l:scope[1][0]+(l:imeth ? 0 : -2),b:method." ".a:1.l:argx." ".b:start_pattern)
   call append(l:scope[1][0]+(l:imeth ? 1 : -2),b:end_pattern)

   " put the yanked content
   execute l:scope[1][0]+(l:imeth ? 1 : 0)."put"

   " delete the selection and call the new method there, if needed
   execute a:firstline.",".a:lastline."d"
   if(l:imeth)
      call append(a:firstline-1,a:1.l:argx.b:line_terminator)
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

function! s:VimRefactRenameAttribute(...)
   let l:scope = s:VimRefactGetClassScope()
   execute l:scope[0][0].",".l:scope[1][0]."s/".b:attr_prefix.a:[1]."/".b:attr_prefix.a:[2]."/g"
endfunction

command! -range -nargs=+ Rem :<line1>,<line2>call <SID>VimRefactExtractMethod(<f-args>)
command! -nargs=+ Rrv :call <SID>VimRefactRenameVariable(<f-args>)
command! -nargs=+ Rra :call <SID>VimRefactRenameAttribute(<f-args>)
