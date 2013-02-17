" Vim indent file
" Language:     SAS 
" Version:  0.2
" Last Change:  2005 Apr. 22
" Maintainer: Jianzhong Liu <jliu7@uiuc.edu>
" Usage:  Do :help sas-indent from Vim

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

"flag indicating if it is in a comments area
let b:comments = 0

"flag indicating if it is in a data or proc step. If at the end of the
"step, there is not a "run;" statement, manually adjust the indent
let b:step = 0
"flag indicating if it is in a macro
let b:macro = 0

setlocal indentexpr=SASGetIndent(v:lnum)
setlocal indentkeys+==~DO,=~END,=~IF,=~THEN,=~ELSE
setlocal indentkeys+==~PROC,=~RUN,=~DATA
setlocal indentkeys+==~%DO,=~%END,=~%IF,=~%THEN,=~%ELSE
setlocal indentkeys+==~%MACRO,=~%MEND

" Only define the function once.
if exists("*SASGetIndent")
  finish
endif

" Similar to java.vim indent file
function! SkipSASBlanksAndComments(startline)
  let lnum = a:startline
  while lnum > 1
    let lnum = prevnonblank(lnum)
    if getline(lnum) =~ '\*/\s*$'
      while getline(lnum) !~ '/\*' && lnum > 1
        let lnum = lnum - 1
      endwhile
      if getline(lnum) =~ '^\s*/\*'
        let lnum = lnum - 1
      else
        break
      endif
    elseif getline(lnum) =~ '^\s*\*'
      let lnum = lnum - 1
    else
      break
    endif
  endwhile
  return lnum
endfunction

function SASGetIndent(lnum)
  let currstat = getline(v:lnum)

  "Skip comments line
  if b:comments == 1 || currstat =~ '^\s*\*' || currstat =~ '^\s*/\*'
    if currstat =~ '^\s*/\*'
      let b:comments = 1
    endif 
    if currstat =~ '\*/\s*$'
      let b:comments = 0
    endif
    return -1
  endif

  "there is a run; statement missing in the last step, manually adjust the indent
  if currstat =~? '^\s*\(data\|proc\)\>' && b:macro == 0
    let b:step = 1
    return 0
  endif
  if currstat =~? '^\s*%macro\>'
    let b:macro = 1
    if b:step == 1
      let b:step = 0
    endif
    return 0
  endif
  
  "Find the previous non-blank and non comments line
  let plnum = SkipSASBlanksAndComments(v:lnum-1)

  "Use zero indent at the top of the file
  if plnum == 0
    return 0
  endif

  let ind = indent(plnum)
  let prevstat = getline(plnum)

  "Add a shiftwidth to statements following if, else, %if, %else
  "do, %do, data, proc and %macro
  if prevstat =~? '^\s*\(do\|%do\|data\|proc\|%macro\|if\|%if\|else\|%else\)\>'
    let ind = ind + &sw

    " Remove unwanted indent after logical and arithmetic ifs
    if (prevstat =~? '^\s*\(if\|else\)\>' 
          \ && prevstat =~? ';' && prevstat !~? '\<do\>'
          \ && currstat !~? '^\s*else\>')
      let ind = ind - &sw
    endif
    if (prevstat =~? '^\s*\(%if\|%else\)\>' 
          \ && prevstat =~? ';' && prevstat !~? '%do\>'
          \ && currstat !~? '^\s*%else\>')
      let ind = ind - &sw
    endif

    " If it's a do; statement, remove the unwanted indent
    if ((currstat =~? '^\s*\(do\|%do\)\>') && (prevstat !~? '^\s*\(do\|%do\)\>')
          \ && (currstat !~? '\<\(to\|%to\)\>'))
      let ind = ind - &sw
    endif

    " If previous statement is like proc ... run; or data ... run;
    " remove the indent
    if prevstat =~? '^\s*\(data\|proc\)\>' && prevstat =~? '\<run\>'
      let ind = ind - &sw
    endif
  endif

  "Subtract a shiftwidth from else, %else, end, %end, run and %mend
  if (currstat =~? '^\s*\(else\|%else\|end\|%end\)\>')
    let ind = ind - &sw
  endif
  
  "If it is a %mend statement, indent is 0
  if currstat =~? '^\s*%mend\>'
    let b:step = 0
    let b:macro = 0
    return 0
  endif

  "If it is run statement, align to the corresponding data or proc statement
  if currstat =~? '\<run\>'
    let b:step = 0
    if b:macro == 0
      return 0
    else
      let ind = ind - &sw
      let alignline = v:lnum-1
      while alignline > 1
        if getline(alignline) =~? '^\s*\(data\|proc\)\>'
          let ind = indent(alignline)
          return ind
        else
          let alignline = alignline-1
        endif
      endwhile
    endif
  endif

  "If previous is a if...; or end; statement and current is a else statment,
  "add an additional indent
  if ((prevstat =~? '\<end\>' && currstat =~? '\<else\>')
        \ || (prevstat =~? '\<%end\>' && currstat =~? '\<%else\>'))
    let ind = ind + &sw
  endif

  return ind
endfunction

" vim:sw=2 ts=8
