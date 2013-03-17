if !g:jsmode || jsmode#Default('b:jsmode', 1)
    finish
endif


" Options {{{

if g:jsmode_options
    setl tabstop=4
    setl softtabstop=4
    setl shiftwidth=4
    setl shiftround
    setl smartindent
    setl smarttab
    setl expandtab
    setl autoindent
    setl number
    setl nowrap
    setl textwidth=79
    setl omnifunc=javascriptcomplete#CompleteJS
    setl complete+=t
endif

" }}}


" Folding {{{

if g:jsmode_folding

    setl fen
    setl foldmethod=syntax
    setl foldlevelstart=1
    setl foldtext=jsmode#FoldText()
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

endif

" }}}


" Indent {{{

if g:jsmode_indent

    setl autoindent
    setl indentexpr=jsmode#indent#expr(v:lnum)
    setl indentkeys=0{,0},0),0],!^F,o,O,e

endif

" }}}


" JsLint {{{

if g:jsmode_lint

    let b:qf_list = []
    let g:qf_list = []

    " DESC: Set commands
    command! -buffer -nargs=0 JsLintToggle :call jsmode#lint#Toggle()
    command! -buffer -nargs=0 JsLintWindowToggle :call jsmode#lint#ToggleWindow()
    command! -buffer -nargs=0 JsLintCheckerToggle :call jsmode#lint#ToggleChecker()
    command! -buffer -nargs=0 JsLint :call jsmode#lint#Check()
    command! -buffer -nargs=0 JsLintAuto :call jsmode#lint#Auto()

    " DESC: Set autocommands
    if g:jsmode_lint_write
        au BufWritePost <buffer> JsLint
    endif

    if g:jsmode_lint_onfly
        au InsertLeave <buffer> JsLint
    endif

    if g:jsmode_lint_message

        " DESC: Show message flag
        let b:show_message = 0

        " DESC: Errors dict
        let b:errors = {}

        au CursorHold <buffer> call jsmode#lint#show_errormessage()
        au CursorMoved <buffer> call jsmode#lint#show_errormessage()

    endif

endif

" }}}


" Tags {{{

if g:jsmode_tags
    command! -buffer -nargs=0 CreateTags :call jsmode#tags#CreateTags()

    setl tags=.tags

    if g:jsmode_tags_onwrite
        au BufWritePost <buffer> call jsmode#tags#CreateTags()
    endif

    exe "nnoremap <silent> <buffer> " . g:jsmode_tags_jump_key . " :call jsmode#tags#JumpTag(expand('<cWORD>'))<cr>"
    exe "vnoremap <silent> <buffer> " . g:jsmode_tags_jump_key . " :<C-U>call jsmode#tags#JumpTag(@*)<cr>"

endif

" }}}


" Utils {{{

if g:jsmode_utils_whitespaces
    au BufWritePre <buffer> call jsmode#utils#ClearWhitespaces()
endif

" }}}


" Breakpoints {{{

" DESC: Set keys
exe "nnoremap <silent> <buffer> <leader>b :call pymode#breakpoint#Set(line('.'))<CR>"

" }}}

" vim: fdm=marker:fdl=0
