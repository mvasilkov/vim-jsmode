Jsmode, Javascript in VIM
#########################

.. note:: Not have Windows support at the moment.


.. contents::


Requirements
============

- VIM >= 7.0 with python support
  (also ``--with-features=big`` if you want use g:pymode_lint_signs)

- Installed JS Interpreter (Ex. node.js)


How to install
==============

Using pathogen_ (recomended)
----------------------------
::

    % cd ~/.vim
    % mkdir -p bundle && cd bundle
    % git clone git://github.com/klen/vim-jsmode.git

- Enable pathogen_ in your ``~/.vimrc``: ::

    " Pathogen load
    filetype off

    call pathogen#infect()
    call pathogen#helptags()

    filetype plugin indent on
    syntax on

Manually
--------
::

    % git clone git://github.com/klen/vim-jsmode.git
    % cd vim-jsmode.vim
    % cp -R * ~/.vim

Then rebuild **helptags** in vim::

    :helptags ~/.vim/doc/


.. note:: **filetype-plugin** (``:help filetype-plugin-on``) and **filetype-indent** (``:help filetype-indent-on``)
    must be enabled for use jsmode.


Settings
========

To change this settings, edit your ``~/.vimrc``: ::

    " Disable jsmode_folding
    let g:jsmode_filding = 0

Default values: ::

    " Enable jsmode
    let g:jsmode = 1

    " Enable jsmode javascript and json syntax
    let g:jsmode_syntax = 1

    " Show indent errors (mix tabs with spaces)
    let g:jsmode_syntax_error_indent = 1

    " Show unused whitespaces
    let g:jsmode_syntax_error_spaces = 1

    " Show wrong brackets
    let g:jsmode_syntax_error_brackets = 1

    " Enable jsmode folding for js files
    let g:jsmode_folding = 1

    " Enable jsmode indent for js files
    let g:jsmode_indent = 1

    " Enable jsmode options for js files
    let g:jsmode_options = 1

    " Remove unused whitespaces on save
    let g:jsmode_utils_whitespaces = 1

    " Manualy set JS interpreter
    " g:jsmode_interpreter

    " Enable jslint
    let g:jsmode_lint = 1

    " Check code every save
    let g:jsmode_lint_write = 1

    " Check code on fly
    let g:jsmode_lint_onfly = 1

    " Show error messages in bottom part of screen
    let g:jsmode_lint_message = 1

    " Path to jslint config file
    let g:jsmode_lint_config = "~/.jslintrc"

    " Auto open cwindow if errors has be founded
    let g:jsmode_lint_cwindow = 1

    " Auto jump on first error
    let g:jsmode_lint_jump = 0

    " Hold cursor on current window when quickfix open
    let g:jsmode_lint_hold = 0

    " Minimal height of jsmode lint window
    let g:jsmode_lint_minheight = 3

    " Maximal height of jsmode lint window
    let g:jsmode_lint_maxheight = 6

    " Place error signs
    let g:jsmode_lint_signs = 1

    " Jsmode ctags support
    let g:jsmode_tags = 1

    " Command for tags creation
    let g:jsmode_tags_cmd = 'ctags'

    " Recreate tags on write
    let g:jsmode_tags_cmd = 'ctags'

    " Jump tag key
    let g:jsmode_tags_jump_key = '<C-c>g'
