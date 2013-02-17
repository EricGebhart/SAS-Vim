"Syntax file
" Language: SAS Tagsets
" Maintainer: Eric Gebhart
" Latest Revision: 15 February 2013

  if exists("b:current_syntax")
      finish
  endif

  syn case ignore

  set foldmethod=indent

  syn keyword tplBasicKeywords put putl putq putlog trigger
  syn keyword tplLoop do done while if else continue stop break iterate next
  syn keyword tplBasicKeywords breakif block unblock
  syn keyword tplBasicKeywords set unset eval

  syn match tplNewline / [Cc][Rr]/
  syn match tplNewline / [Nn][Ll]/

  syn keyword tpltrigger trigger
  syn match tplstartfinish  /start\:/
  syn match tplstartfinish  /finish\:/
  syn match tplend /end;/
  syn match tpldefinetagset /define[ *]tagset .*;$/
  syn match tpldefineevent /define[ *]event .*;$/
  syn keyword tplTodo TODO FIXME XXX NOTE

  "syntax region tplBlock start=/define/ end=/end/ contains=tplBlock fold transparent
  "syn region tpltagset start=tpledefinetagset end=tplend fold transparent contains=all
  "syn region tplevent start=tpledefineevent end=tplend fold transparent contained contains=ALLBUT,tpltagset
  "syn region tplloop start="do" end="done;" fold transparent contained contains=ALLBUT,tplevent, tpltagset

  syn region tplComment start='/\*' end='\*/' contains=tplTodo

  syntax region tplString start=/"/ skip=/\\"/ end=/"/
  syntax region tplString start=/'/ skip=/\\'/ end=/'/

  "syn match tplvariable /[$]+[A-Za-z_][A-Za-z_0-9-]*/

  syn match  tplvariable  /$\h\w*/  contained display

  highlight link tpldefineevent     Define
  highlight link tpltrigger     Define
  highlight link tplend         Define
  highlight link tplTodo        Todo
  highlight link tplComment      Comment
  highlight link tplBasicKeywords   Statement
  highlight link tplvariable     Type
  highlight link tplLoop         Type
  highlight link tplString     Constant
  highlight link tplNewline    Comment
  highlight link tplstartfinish  PreProc

  let b:current_syntax = "tpl"
