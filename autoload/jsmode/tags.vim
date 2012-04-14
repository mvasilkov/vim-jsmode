fun! jsmode#tags#CreateTags() "{{{
    let js = g:jsmode_tags_cmd . ' -R --languages=js -f .tags --exclude=_ ' . getcwd()
    call system(js)
endfunction "}}}


fun! jsmode#tags#JumpTag(word) "{{{
    try
        execute 'stjump' a:word
    catch /.*:E426:.*/
        let ignorecase = &ignorecase
        set ignorecase
        try
            execute 'stjump' a:word
        catch /.*:E426:.*/
            call jsmode#WideMessage('Tag "' . a:word . '" not found.')
        endtry
        let &ignorecase = ignorecase
    endtry

        return
endfunction "}}}
