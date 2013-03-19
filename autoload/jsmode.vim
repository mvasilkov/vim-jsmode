" Jsmode base functions


fun! jsmode#Default(name, default) "{{{
    " DESC: Set default value if it not exists
    "
    if !exists(a:name)
        let {a:name} = a:default
        return 0
    endif
    return 1
endfunction "}}}


fun! jsmode#QuickfixOpen(onlyRecognized, holdCursor, maxHeight, minHeight, jumpError) "{{{
    " DESC: Open quickfix window
    "
    let numErrors = len(filter(getqflist(), 'v:val.valid'))
    let numOthers = len(getqflist()) - numErrors
    if numErrors > 0 || (!a:onlyRecognized && numOthers > 0)
        botright copen
        exe max([min([line("$"), a:maxHeight]), a:minHeight]) . "wincmd _"
        if a:jumpError
            cc
        elseif a:holdCursor
            wincmd p
        endif
    else
        cclose
    endif
    redraw
    if numOthers > 0
        echo printf('Quickfix: %d(+%d)', numErrors, numOthers)
    else
        echo printf('Quickfix: %d', numErrors)
    endif
endfunction "}}}


fun! jsmode#PlaceSigns() "{{{
    " DESC: Place error signs
    "
    sign unplace *
    for item in filter(getqflist(), 'v:val.bufnr != ""')
        execute printf('silent! sign place 1 line=%d name=%s buffer=%d', item.lnum, item.type, item.bufnr)
    endfor
endfunction "}}}


fun! jsmode#CheckInterpreter(name) "{{{
    " DESC: Check program is executable or redifined by user.
    "
    let name = 'g:' . a:name
    if jsmode#Default(name, a:name)
        return 1
    elseif executable('node')
        let {name} = 'node'
    elseif executable('nodejs')
        let {name} = 'nodejs'
    else
        return 0
    endif
    return 1
endfunction "}}}


fun! jsmode#TempBuffer() "{{{
    " DESC: Open temp buffer.
    "
    pclose | botright 8new
    setlocal buftype=nofile bufhidden=delete noswapfile nowrap previewwindow
    redraw
endfunction "}}}


fun! jsmode#ShowStr(str) "{{{
    " DESC: Open temp buffer with `str`.
    "
    let g:jsmode_curbuf = bufnr("%")
    call jsmode#TempBuffer()
    put! =a:str
    redraw
    normal gg 
    wincmd p
endfunction "}}}


fun! jsmode#ShowCommand(cmd) "{{{
    " DESC: Run command and open temp buffer with result
    "
    call jsmode#TempBuffer()
    try
        silent exec 'r!' . a:cmd
    catch /.*/
        close
        echoerr 'Command fail: '.a:cmd
    endtry
    redraw
    normal gg
    wincmd p
endfunction "}}}


fun! jsmode#RunShell(cmd, stdin) "{{{
    let sh = &shell
    let &shell = '/bin/bash'
    let result = system(a:cmd, a:stdin)
    let &shell = sh
    if v:shell_error
        echoerr result
        throw 'CmdError'
    end
    return result
endfunction "}}}


fun! jsmode#WideMessage(msg) "{{{
    " DESC: Show wide message

    let x=&ruler | let y=&showcmd
    set noruler noshowcmd
    redraw
    echo strpart(a:msg, 0, &columns-1)
    let &ruler=x | let &showcmd=y
endfunction "}}}


fun! jsmode#FoldText() "{{{
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
endfunction "}}}


let s:breakpoint = 'debugger; // XXX: Debug'
fun! jsmode#breakpoint#Set(lnum) "{{{
    let line = getline(a:lnum)
    if strridx(line, s:breakpoint) != -1
        normal dd
    else
        let plnum = prevnonblank(a:lnum)
        call append(line('.')-1, repeat(' ', indent(plnum)).s:breakpoint)
        normal k
    endif

    " Save file
    if &modifiable && &modified | noautocmd write | endif	

endfunction "}}}
" vim: fdm=marker:fdl=0
