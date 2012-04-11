fun! jsmode#lint#Check()

    if !g:jsmode_lint | return | endif

    let b:errors = {}

    if &modifiable && &modified
        try
            write
        catch /E212/
            echohl Error | echo "File modified and I can't save it. Cancel code checking." | echohl None
            return 0
        endtry
    endif	

    let b:qf_list = jsmode#lint#Run()

    if g:qf_list != b:qf_list

        call setqflist(b:qf_list, 'r')

        let g:qf_list = b:qf_list

        if g:jsmode_lint_message
            for v in b:qf_list
                let b:errors[v['lnum']] = v['text']
            endfor
            call jsmode#lint#show_errormessage()
        endif

        if g:jsmode_lint_cwindow
            call jsmode#QuickfixOpen(0, g:jsmode_lint_hold, g:jsmode_lint_maxheight, g:jsmode_lint_minheight, g:jsmode_lint_jump)
        endif

    endif

    if g:jsmode_lint_signs
        call jsmode#PlaceSigns()
    endif

endfunction


fun! jsmode#lint#Toggle() "{{{
    let g:jsmode_lint = g:jsmode_lint ? 0 : 1
    call jsmode#lint#toggle_win(g:jsmode_lint, "jsmode lint")
endfunction "}}}


fun! jsmode#lint#ToggleWindow() "{{{
    let g:jsmode_lint_cwindow = g:jsmode_lint_cwindow ? 0 : 1
    call jsmode#lint#toggle_win(g:jsmode_lint_cwindow, "jsmode lint cwindow")
endfunction "}}}


fun! jsmode#lint#ToggleChecker() "{{{
    let g:jsmode_lint_checker = g:jsmode_lint_checker == "pylint" ? "pyflakes" : "pylint"
    echomsg "jsmode lint checker: " . g:jsmode_lint_checker
endfunction "}}}


fun! jsmode#lint#toggle_win(toggle, msg) "{{{
    if a:toggle
        echomsg a:msg." enabled"
        botright cwindow
        if &buftype == "quickfix"
            wincmd p
        endif
    else
        echomsg a:msg." disabled"
        cclose
    endif
endfunction "}}}


fun! jsmode#lint#show_errormessage() "{{{
    if !len(b:errors) | return | endif
    let cursor = getpos(".")
    if has_key(b:errors, l:cursor[1])
        call jsmode#WideMessage(b:errors[l:cursor[1]])
        let b:show_message = 1
    else
        let b:show_message = 0
        echo
    endif
endfunction " }}}


fun! jsmode#lint#Run() "{{{
    let cmd = "cd " . g:jsmode_libs . " && " . g:jsmode_interpreter . " runjslint.js "
    let stdin =  join(g:jsmode_lint_rc + getline(0, '$'), "\n")
    let output = jsmode#RunShell(cmd, stdin)
    let result = []
    for error in split(output, "\n")
        let parts = matchlist(error, '\v(\d+):(\d+):([A-Z]+):(.*)')
        if !empty(parts)
            let qf_item = {}
            let qf_item.bufnr = bufnr('%')
            let qf_item.filename = expand('%')
            let qf_item.lnum = parts[1] - len(g:jsmode_lint_rc)
            let qf_item.col = parts[2]
            let qf_item.text = parts[4]
            if parts[3] == 'ERROR'
                let qf_item.type = 'E'
            else
                let qf_item.type = 'W'
            endif
            call add(result, qf_item)
        endif
    endfor
    return result
endfunction "}}}
