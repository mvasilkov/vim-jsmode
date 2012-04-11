" vim: ft=vim:fdm=marker

" OPTION: g:jsmode_syntax -- bool.
call jsmode#Default('g:jsmode_syntax', 1)

" DESC: Disable script loading
if jsmode#Default('b:current_syntax', 'javascript') || !g:jsmode_syntax
    finish
endif

" OPTION: g:jsmode_syntax_jsdoc -- bool (true)
call jsmode#Default('g:jsmode_syntax_jsdoc', 1)

" OPTION: g:jsmode_syntax_domhtmlcss -- bool (false)
call jsmode#Default('g:jsmode_syntax_domhtmlcss', 0)

" OPTION: g:jsmode_syntax_fold -- bool (false)
call jsmode#Default('g:jsmode_syntax_fold', 1)

" OPTION: g:jsmode_syntax_error_indent -- bool (true)
call jsmode#Default('g:jsmode_syntax_error_indent', 1)

" OPTION: g:jsmode_syntax_error_spaces -- bool (true)
call jsmode#Default('g:jsmode_syntax_error_spaces', 1)

" OPTION: g:jsmode_syntax_error_brackets -- bool (true)
call jsmode#Default('g:jsmode_syntax_error_brackets', 1)


"" dollar sign is permittd anywhere in an identifier
setlocal iskeyword+=$

syn sync fromstart
" syn case match


" Errors {{{
" ==========
"

    " Indent errors (mix space and tabs)
    if (g:jsmode_syntax_error_indent)
        syn match javaScriptIndentError	"^\s*\( \t\|\t \)\s*\S"me=e-1 display
    endif

    " Trailing space errors
    if (g:jsmode_syntax_error_spaces)
        syn match javaScriptSpaceError	"\s\+$" display
    endif

    " Wrong parenthesis
    if (g:jsmode_syntax_error_brackets)

        syn match   javaScriptParensError    ")\|}\|\]"
        syn match   javaScriptParensErrA     contained "\]"
        syn match   javaScriptParensErrB     contained ")"
        syn match   javaScriptParensErrC     contained "}"

    endif

" }}}


" Comments {{{
" ============

    syn keyword javaScriptCommentTodo    TODO FIXME XXX TBD contained
    syn region  javaScriptLineComment    start=+\/\/+ end=+$+ keepend contains=javaScriptCommentTodo,@Spell
    syn region  javaScriptEnvComment     start="\%^#!" end="$" display
    syn region  javaScriptLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend contains=javaScriptCommentTodo,@Spell fold
    syn region  javaScriptCvsTag         start="\$\cid:" end="\$" oneline contained
    syn region  javaScriptComment        start="/\*"  end="\*/" contains=javaScriptCommentTodo,javaScriptCvsTag,@Spell fold

" }}}


" JSDocs {{{
" ==========

    if (g:jsmode_syntax_jsdoc)

        syn case ignore

        syn region javaScriptDocComment      matchgroup=javaScriptComment start="/\*\*\s*"  end="\*/" contains=javaScriptDocTags,javaScriptCommentTodo,javaScriptCvsTag,@javaScriptHtml,@Spell fold

        " tags containing a param
        syn match  javaScriptDocTags         contained "@\(augments\|base\|borrows\|class\|constructs\|default\|exception\|exports\|extends\|file\|member\|memberOf\|module\|name\|namespace\|optional\|requires\|title\|throws\|version\)\>" nextgroup=javaScriptDocParam skipwhite
        " tags containing type and param
        syn match  javaScriptDocTags         contained "@\(argument\|param\|property\)\>" nextgroup=javaScriptDocType skipwhite
        " tags containing type but no param
        syn match  javaScriptDocTags         contained "@\(type\|return\|returns\)\>" nextgroup=javaScriptDocTypeNoParam skipwhite
        " tags containing references
        syn match  javaScriptDocTags         contained "@\(lends\|link\|see\)\>" nextgroup=javaScriptDocSeeTag skipwhite
        " other tags (no extra syntax)
        syn match  javaScriptDocTags         contained "@\(access\|addon\|alias\|author\|beta\|constant\|constructor\|copyright\|deprecated\|description\|event\|example\|exec\|field\|fileOverview\|fileoverview\|function\|global\|ignore\|inner\|license\|overview\|private\|protected\|project\|public\|readonly\|since\|static\)\>"

        syn region javaScriptDocType         start="{" end="}" oneline contained nextgroup=javaScriptDocParam skipwhite
        syn match  javaScriptDocType         contained "\%(#\|\"\|\w\|\.\|:\|\/\)\+" nextgroup=javaScriptDocParam skipwhite
        syn region javaScriptDocTypeNoParam  start="{" end="}" oneline contained
        syn match  javaScriptDocTypeNoParam  contained "\%(#\|\"\|\w\|\.\|:\|\/\)\+"
        syn match  javaScriptDocParam        contained "\%(#\|\"\|{\|}\|\w\|\.\|:\|\/\)\+"
        syn region javaScriptDocSeeTag       contained matchgroup=javaScriptDocSeeTag start="{" end="}" contains=javaScriptDocTags

        syn case match

    endif

" }}}


" Keywords {{{
" ============

    "" syntax in the JavaScript code
    syn match   javaScriptSpecial        "\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\."
    syn region  javaScriptStringD        start=+"+  skip=+\\\\\|\\$"+  end=+"+  contains=javaScriptSpecial,@htmlPreproc
    syn region  javaScriptStringS        start=+'+  skip=+\\\\\|\\$'+  end=+'+  contains=javaScriptSpecial,@htmlPreproc
    syn region  javaScriptRegexpCharClass start=+\[+ end=+\]+ contained
    syn region  javaScriptRegexpString   start=+\(\(\(return\|case\)\s\+\)\@<=\|\(\([)\]"']\|\d\|\w\)\s*\)\@<!\)/\(\*\|/\)\@!+ skip=+\\\\\|\\/+ end=+/[gimy]\{,4}+ contains=javaScriptSpecial,javaScriptRegexpCharClass,@htmlPreproc oneline
    syn match   javaScriptNumber         /\<-\=\d\+L\=\>\|\<0[xX]\x\+\>/
    syn match   javaScriptFloat          /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
    syn match   javaScriptLabel          /\<\w\+\(\s*:\)\@=/

    "" JavaScript Prototype
    syn keyword javaScriptPrototype      prototype

    "" Program Keywords
    syn keyword javaScriptSource         import export
    syn keyword javaScriptType           const undefined var void yield 
    syn keyword javaScriptOperator       delete new in instanceof let typeof
    syn keyword javaScriptBoolean        true false
    syn keyword javaScriptNull           null
    syn keyword javaScriptThis           this

    "" Statement Keywords
    syn keyword javaScriptConditional    if else
    syn keyword javaScriptRepeat         do while for
    syn keyword javaScriptBranch         break continue switch case default return
    syn keyword javaScriptStatement      try catch throw with finally

    syn keyword javaScriptGlobalObjects  Array Boolean Date Function Infinity JavaArray JavaClass JavaObject JavaPackage Math Number NaN Object Packages RegExp String Undefined java netscape sun

    syn keyword javaScriptExceptions     Error EvalError RangeError ReferenceError SyntaxError TypeError URIError

    syn keyword javaScriptFutureKeys     abstract enum int short boolean export interface static byte extends long super char final native synchronized class float package throws goto private transient debugger implements protected volatile double import public

    " DOM2 Objects
    syn keyword javaScriptGlobalObjects  DOMImplementation DocumentFragment Document Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction
    syn keyword javaScriptExceptions     DOMException

    " DOM2 CONSTANT
    syn keyword javaScriptDomErrNo       INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
    syn keyword javaScriptDomNodeConsts  ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE

    " HTML events and internal variables
    syn case ignore
    syn keyword javaScriptHtmlEvents     onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize
    syn case match

" }}}


" DOMHTMLCSS {{{
" ==============
"
    if (g:jsmode_syntax_domhtmlcss)

        " DOM2 things
        syn match javaScriptDomElemAttrs     contained /\%(nodeName\|nodeValue\|nodeType\|parentNode\|childNodes\|firstChild\|lastChild\|previousSibling\|nextSibling\|attributes\|ownerDocument\|namespaceURI\|prefix\|localName\|tagName\)\>/
        syn match javaScriptDomElemFuncs     contained /\%(insertBefore\|replaceChild\|removeChild\|appendChild\|hasChildNodes\|cloneNode\|normalize\|isSupported\|hasAttributes\|getAttribute\|setAttribute\|removeAttribute\|getAttributeNode\|setAttributeNode\|removeAttributeNode\|getElementsByTagName\|getAttributeNS\|setAttributeNS\|removeAttributeNS\|getAttributeNodeNS\|setAttributeNodeNS\|getElementsByTagNameNS\|hasAttribute\|hasAttributeNS\)\>/ nextgroup=javaScriptParen skipwhite
        " HTML things
        syn match javaScriptHtmlElemAttrs    contained /\%(className\|clientHeight\|clientLeft\|clientTop\|clientWidth\|dir\|id\|innerHTML\|lang\|length\|offsetHeight\|offsetLeft\|offsetParent\|offsetTop\|offsetWidth\|scrollHeight\|scrollLeft\|scrollTop\|scrollWidth\|style\|tabIndex\|title\)\>/
        syn match javaScriptHtmlElemFuncs    contained /\%(blur\|click\|focus\|scrollIntoView\|addEventListener\|dispatchEvent\|removeEventListener\|item\)\>/ nextgroup=javaScriptParen skipwhite

        " CSS Styles in JavaScript
        syn keyword javaScriptCssStyles      contained color font fontFamily fontSize fontSizeAdjust fontStretch fontStyle fontVariant fontWeight letterSpacing lineBreak lineHeight quotes rubyAlign rubyOverhang rubyPosition
        syn keyword javaScriptCssStyles      contained textAlign textAlignLast textAutospace textDecoration textIndent textJustify textJustifyTrim textKashidaSpace textOverflowW6 textShadow textTransform textUnderlinePosition
        syn keyword javaScriptCssStyles      contained unicodeBidi whiteSpace wordBreak wordSpacing wordWrap writingMode
        syn keyword javaScriptCssStyles      contained bottom height left position right top width zIndex
        syn keyword javaScriptCssStyles      contained border borderBottom borderLeft borderRight borderTop borderBottomColor borderLeftColor borderTopColor borderBottomStyle borderLeftStyle borderRightStyle borderTopStyle borderBottomWidth borderLeftWidth borderRightWidth borderTopWidth borderColor borderStyle borderWidth borderCollapse borderSpacing captionSide emptyCells tableLayout
        syn keyword javaScriptCssStyles      contained margin marginBottom marginLeft marginRight marginTop outline outlineColor outlineStyle outlineWidth padding paddingBottom paddingLeft paddingRight paddingTop
        syn keyword javaScriptCssStyles      contained listStyle listStyleImage listStylePosition listStyleType
        syn keyword javaScriptCssStyles      contained background backgroundAttachment backgroundColor backgroundImage gackgroundPosition backgroundPositionX backgroundPositionY backgroundRepeat
        syn keyword javaScriptCssStyles      contained clear clip clipBottom clipLeft clipRight clipTop content counterIncrement counterReset cssFloat cursor direction display filter layoutGrid layoutGridChar layoutGridLine layoutGridMode layoutGridType
        syn keyword javaScriptCssStyles      contained marks maxHeight maxWidth minHeight minWidth opacity MozOpacity overflow overflowX overflowY verticalAlign visibility zoom cssText
        syn keyword javaScriptCssStyles      contained scrollbar3dLightColor scrollbarArrowColor scrollbarBaseColor scrollbarDarkShadowColor scrollbarFaceColor scrollbarHighlightColor scrollbarShadowColor scrollbarTrackColor

        " Highlight ways
        syn match javaScriptDotNotation      "\." nextgroup=javaScriptPrototype,javaScriptDomElemAttrs,javaScriptDomElemFuncs,javaScriptHtmlElemAttrs,javaScriptHtmlElemFuncs
        syn match javaScriptDotNotation      "\.style\." nextgroup=javaScriptCssStyles

    endif

" }}}


" Code blocks {{{
" ===============
"
    " there is a name collision with javaScriptExpression in html.vim, hence the use of the '2' here
    syn cluster javaScriptExpression2 contains=javaScriptComment,javaScriptLineComment,javaScriptDocComment,javaScriptStringD,javaScriptStringS,javaScriptRegexpString,javaScriptNumber,javaScriptFloat,javaScriptSource,javaScriptThis,javaScriptType,javaScriptOperator,javaScriptBoolean,javaScriptNull,javaScriptFunction,javaScriptGlobalObjects,javaScriptExceptions,javaScriptFutureKeys,javaScriptDomErrNo,javaScriptDomNodeConsts,javaScriptHtmlEvents,javaScriptDotNotation,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError
    syn cluster javaScriptAll       contains=@javaScriptExpression2,javaScriptLabel,javaScriptConditional,javaScriptRepeat,javaScriptBranch,javaScriptStatement,javaScriptTernaryIf,javaScriptIndentError,javaScriptSpaceError
    syn region  javaScriptBracket   matchgroup=javaScriptBracket transparent start="\[" end="\]" contains=@javaScriptAll,javaScriptParensErrB,javaScriptParensErrC,javaScriptBracket,javaScriptParen,javaScriptBlock,@htmlPreproc
    syn region  javaScriptParen     matchgroup=javaScriptParen   transparent start="("  end=")"  contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrC,javaScriptParen,javaScriptBracket,javaScriptBlock,@htmlPreproc
    syn region  javaScriptBlock     matchgroup=javaScriptBlock   transparent start="{"  end="}"  contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrB,javaScriptParen,javaScriptBracket,javaScriptBlock,@htmlPreproc 
    syn region  javaScriptTernaryIf matchgroup=javaScriptTernaryIfOperator start=+?+  end=+:+  contains=@javaScriptExpression2

" }}}

syn sync clear
syn sync ccomment javaScriptComment minlines=200
syn sync match javaScriptHighlight grouphere javaScriptBlock /{/


" Fold control {{{
" ================
"

    if (g:jsmode_syntax_fold)
        syn match   javaScriptFunction       /\<function\>/ nextgroup=javaScriptFuncName skipwhite
        syn match   javaScriptOpAssign       /=\@<!=/ nextgroup=javaScriptFuncBlock skipwhite skipempty
        syn region  javaScriptFuncName       contained matchgroup=javaScriptFuncName start=/\%(\$\|\w\)*\s*(/ end=/)/ contains=javaScriptLineComment,javaScriptComment nextgroup=javaScriptFuncBlock skipwhite skipempty
        syn region  javaScriptFuncBlock      contained matchgroup=javaScriptFuncBlock start="{" end="}" contains=@javaScriptAll,javaScriptParensErrA,javaScriptParensErrB,javaScriptParen,javaScriptBracket,javaScriptBlock fold
    else
        syn keyword javaScriptFunction       function
    endif

" }}}


" Highlight {{{
" =============

    hi def link javaScriptComment              Comment
    hi def link javaScriptLineComment          Comment
    hi def link javaScriptEnvComment           PreProc
    hi def link javaScriptDocComment           Comment
    hi def link javaScriptCommentTodo          Todo
    hi def link javaScriptCvsTag               Function
    hi def link javaScriptDocTags              Special
    hi def link javaScriptDocSeeTag            Function
    hi def link javaScriptDocType              Type
    hi def link javaScriptDocTypeNoParam       Type
    hi def link javaScriptDocParam             Label
    hi def link javaScriptStringS              String
    hi def link javaScriptStringD              String
    hi def link javaScriptTernaryIfOperator    Conditional
    hi def link javaScriptRegexpString         String
    hi def link javaScriptRegexpCharClass      Character
    hi def link javaScriptCharacter            Character
    hi def link javaScriptPrototype            Type
    hi def link javaScriptConditional          Conditional
    hi def link javaScriptBranch               Conditional
    hi def link javaScriptRepeat               Repeat
    hi def link javaScriptStatement            Statement
    hi def link javaScriptFunction             Function
    hi def link javaScriptError                Error
    hi def link javaScriptParensError          Error
    hi def link javaScriptParensErrA           Error
    hi def link javaScriptParensErrB           Error
    hi def link javaScriptParensErrC           Error
    hi def link javaScriptSpaceError           Error
    hi def link javaScriptIndentError          Error
    hi def link javaScriptOperator             Operator
    hi def link javaScriptType                 Type
    hi def link javaScriptThis                 Type
    hi def link javaScriptNull                 Type
    hi def link javaScriptNumber               Number
    hi def link javaScriptFloat                Number
    hi def link javaScriptBoolean              Boolean
    hi def link javaScriptLabel                Label
    hi def link javaScriptSpecial              Special
    hi def link javaScriptSource               Special
    hi def link javaScriptGlobalObjects        Special
    hi def link javaScriptExceptions           Special

    hi def link javaScriptDomErrNo             Constant
    hi def link javaScriptDomNodeConsts        Constant
    hi def link javaScriptDomElemAttrs         Label
    hi def link javaScriptDomElemFuncs         PreProc

    hi def link javaScriptHtmlEvents           Special
    hi def link javaScriptHtmlElemAttrs        Label
    hi def link javaScriptHtmlElemFuncs        PreProc

    hi def link javaScriptCssStyles            Label

" }}}


" Define the htmlJavaScript for HTML syntax html.vim
"syntax clear htmlJavaScript
"syntax clear javaScriptExpression
syn cluster  htmlJavaScript contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError
syn cluster  javaScriptExpression contains=@javaScriptAll,javaScriptBracket,javaScriptParen,javaScriptBlock,javaScriptParenError,@htmlPreproc
" Vim's default html.vim highlights all javascript as 'Special'
hi! def link javaScript NONE
