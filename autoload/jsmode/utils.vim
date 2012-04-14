fun! jsmode#utils#ClearWhitespaces() "{{{
    
    if g:jsmode_largefile && getfsize(expand('%:p')) >= g:jsmode_largefile*1024
        return
    endif                                                         
    call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

endfunction "}}}
