"Author: Eric Gebhart
"email: e.a.gebhart@gmail.com"

"Sniff out the file type for tagsets, otherwise they will be set to smarty
"filetype."

function! SetTagsetFileType()

    let nline = 0
    while nline < 30
        let nline = nextnonblank(nline+1)
        if getline(nline) =~ '^\s*\<\define[ *]tagset\>'
            setlocal filetype=tpl
            break
        endif
    endwhile
endfunction

autocmd BufReadPost * SetTagsetFileType()

