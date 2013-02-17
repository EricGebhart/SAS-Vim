
" Vim indent file
" Language:    SAS TPL
" Maintainer:  Eric Gebhart <e.a.gebhart@gmail.com>
" Created:     2013 Feb 15
" Last Change: 2013 Feb 15


if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GettplIndent(v:lnum)
setlocal indentkeys&
setlocal indentkeys+==end
setlocal indentkeys+==start
setlocal indentkeys+==finish
setlocal indentkeys+==do
setlocal indentkeys+==done
setlocal indentkeys+==define
setlocal indentkeys+==else

if exists("*GettplIndent")
    finish
endif


function! s:GetPrevNonCommentLineNum( line_num )

    " Skip lines starting with a comment
    "These are Pascal comments. So probably should change them.
    "Although I personally like my comments to match my indention
    let SKIP_LINES = '^\s*\(\((\*\)\|\(\*\ \)\|\(\*)\)\|{\|}\)'

    let nline = a:line_num
    while nline > 0
        let nline = prevnonblank(nline-1)
        if getline(nline) !~? SKIP_LINES
            break
        endif
    endwhile

    return nline
endfunction


function! GettplIndent( line_num )
    " Line 0 always goes at column 0
    if a:line_num == 0
        return 0
    endif

    ""let this_codeline = getline( a:line_num )
    let this_codeline = getline('.')

    " If in the middle of a three-part comment
    if this_codeline =~ '^\s*\*'
        return indent( a:line_num )
    endif

    let prev_codeline_num = s:GetPrevNonCommentLineNum( a:line_num )
    let prev_codeline = getline( prev_codeline_num )
    let indnt = indent( prev_codeline_num )

    " If the previous line was indenting...
    if prev_codeline =~ '^\s*\<\(define\|do\|start\|finish\|else\)\>'
        " then indent.
        let indnt = indnt + &shiftwidth
    endif

    " If we just closed a bracket that started on a previous line, then
    " unindent. But don't return yet -- we need to check for further
    " unindentation (for end/until/else)
    if prev_codeline =~ '^[^(]*[^*])'
        let indnt = indnt - &shiftwidth
    endif

    "Attempt to get back to where define is
    if this_codeline =~ '^\s*\<\end\>'
        return 2 * &shiftwidth
    endif

    " At the end of a block, we have to unindent both the current line
    " (the "end" for instance) and the newly-created line.
    if this_codeline =~ '^\s*\<\(end\|done\|else\)\>'
        return indnt - &shiftwidth
    endif

    "if finish is right now, we need to unindent if we aren't under a define
    "event statement..
    "This isn't actually working...
    if this_codeline =~ '^\s*\<\finish:\>'
        if prev_codeline !~? '^\s*\<define\>'
            return indnt - &shiftwidth
        endif
    endif


    " If we have opened a bracket and it continues over one line,
    " then indent once.
    "
    " RE = an opening bracket followed by any amount of anything other
    " than a closing bracket and then the end-of-line.
    "
    " If we didn't include the end of line, this RE would match even
    " closed brackets, since it would match everything up to the closing
    " bracket.
    "
    " This test isn't clever enough to handle brackets inside strings or
    " comments.
    if prev_codeline =~ '([^*]\=[^)]*$'
        return indnt + &shiftwidth
    endif

    return indnt
endfunction
