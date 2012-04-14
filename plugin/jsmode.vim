let g:jsmode_version = "0.1.4"

com! JsmodeVersion echomsg "Current jsmode version: " . g:jsmode_version


" OPTION: g:jsmode -- bool. Run jsmode.
if jsmode#Default('g:jsmode', 1) || !g:jsmode
    " DESC: Disable script loading
    finish
endif

" OPTION: g:jsmode_syntax -- bool. Enable jsmode syntax for js files.
call jsmode#Default("g:jsmode_syntax", 1)

" OPTION: g:jsmode_folding -- bool. Enable jsmode folding for js files.
call jsmode#Default("g:jsmode_folding", 1)

" OPTION: g:jsmode_indent -- bool. Enable jsmode indent for js files.
call jsmode#Default("g:jsmode_indent", 1)

" OPTION: g:jsmode_utils_whitespaces -- bool. Remove unused whitespaces on save
call jsmode#Default("g:jsmode_utils_whitespaces", 1)

" OPTION: g:jsmode_options -- bool. Enable jsmode options for js files.
call jsmode#Default("g:jsmode_options", 1)

" OPTION: g:jsmode_largefile -- int. Maximal size of file for run
" jslint and some utils commands (Kb). If 0 option is disabled.
" is set.
call jsmode#Default("g:jsmode_largefile", 100)

" Check JS Interpreter
let s:js = jsmode#CheckInterpreter('jsmode_interpreter')

if s:js
    let g:jsmode_libs = expand('<sfile>:p:h:h') . "/jslibs"
    if has('win32')
        let g:jsmode_libs = substitute(g:jsmode_libs, '/', '\', 'g')
    endif
endif


" Lint {{{

if s:js && (!jsmode#Default("g:jsmode_lint", 1) || g:jsmode_lint)

    " OPTION: g:jsmode_lint_write -- bool. Check code every save.
    call jsmode#Default("g:jsmode_lint_write", 1)

    " OPTION: g:jsmode_lint_onfly -- bool. Check code on fly.
    call jsmode#Default("g:jsmode_lint_onfly", 0)

    " OPTION: g:jsmode_lint_message -- bool. Show current line error message
    call jsmode#Default("g:jsmode_lint_message", 1)

    " OPTION: g:jsmode_lint_config -- str. Path to jslint config file
    call jsmode#Default("g:jsmode_lint_config", $HOME . "/.jslintrc")

    " OPTION: g:jsmode_lint_cwindow -- bool. Auto open cwindow if errors find
    call jsmode#Default("g:jsmode_lint_cwindow", 1)

    " OPTION: g:jsmode_lint_jump -- int. Jump on first error.
    call jsmode#Default("g:jsmode_lint_jump", 0)

    " OPTION: g:jsmode_lint_hold -- int. Hold cursor on current window when
    " quickfix open
    call jsmode#Default("g:jsmode_lint_hold", 0)

    " OPTION: g:jsmode_lint_minheight -- int. Minimal height of jsmode lint window
    call jsmode#Default("g:jsmode_lint_minheight", 3)

    " OPTION: g:jsmode_lint_maxheight -- int. Maximal height of jsmode lint window
    call jsmode#Default("g:jsmode_lint_maxheight", 6)

    " OPTION: g:jsmode_lint_signs -- bool. Place error signs
    if !jsmode#Default("g:jsmode_lint_signs", 1) || g:jsmode_lint_signs

        " DESC: Signs definition
        sign define W text=WW texthl=Warning
        sign define E text=EE texthl=Error

    endif

    " DESC: Set default pylint configuration
    if !filereadable(g:jsmode_lint_config)
        let g:jsmode_lint_config = expand("<sfile>:p:h:h") . "/jslint.rc"
    endif

    let g:jsmode_lint_rc = readfile(g:jsmode_lint_config)

endif

" }}}


" Tags {{{

if (!jsmode#Default("g:jsmode_tags", 1) || g:jsmode_lint)

    let g:jsmode_tags_langdef = join([ '--langdef=js', '--langmap=js:.js',
\       '--regex-js=/([A-Za-z0-9._$]+)[ \t]*=[ \t]*function[ \t]*\(/\1/f,function/',
\       '--regex-js=/function[ \t]+([A-Za-z0-9._$]+)[ \t]*\([^\]\)]*\)/\1/f,function/',
\       '--regex-js=/var ([A-Za-z0-9._$]+)[ \t]*[=][ \t]*([A-Za-z0-9._"\$\#\[\{]+)[,|;]/\1/v,variable/',
\       '--regex-js=/([A-Za-z0-9._$]+)[ \t]*:[ \t]*function[ \t]*\(/\1/m,method/',
\       '--regex-js=/([A-Za-z0-9._$]+)[ \t]*:[ \t]*new[ \t]*/\1/m,method/',
\       '--regex-js=/([A-Za-z0-9._$]+)[ \t]*=[ \t]*new[ \t]+\(/\1/o,object/',
\       '--regex-js=/([A-Za-z0-9._$]+)[ \t]*=[ \t]*([A-Za-z0-9._"\$\#]+)extend\(/\1/c,class/'
\   ], ' ')

    call jsmode#Default('g:jsmode_tags_cmd', 'ctags')

    call jsmode#Default('g:jsmode_tags_onwrite', 1)

    call jsmode#Default('g:jsmode_tags_jump_key', '<C-c>g')

endif

" }}}


" vim: fdm=marker:fdl=0
