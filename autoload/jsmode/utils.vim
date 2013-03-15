fun! jsmode#utils#ClearWhitespaces() "{{{
    
    if g:jsmode_largefile && getfsize(expand('%:p')) >= g:jsmode_largefile*1024
        return
    endif                                                         
    let cursor_pos = getpos('.')
    silent! %s/\s\+$//
    call setpos('.', cursor_pos)

endfunction "}}}
