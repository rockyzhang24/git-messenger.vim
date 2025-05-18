if exists('b:current_syntax')
    finish
endif

if g:git_messenger_popup_content_margins
    let margin_pat = '^ '
else
    let margin_pat = '^'
endif

syn sync fromstart

exe 'syn match gitmessengerHeader "' . margin_pat . '\%(History\|Commit\|\%(Author \|Committer \)\=Date\|Author\|Committer\):" display'
exe 'syn match gitmessengerHash "\%(' . margin_pat . 'Commit: \+\)\@<=[[:xdigit:]]\+" display'
exe 'syn match gitmessengerHistory "\%(' . margin_pat . 'History: \+\)\@<=#\d\+" display'
exe 'syn match gitmessengerEmail "\%(' . margin_pat . '\%(Author\|Committer\): \+.*\)\@<=<.\+>" display'

" Diff included in popup
" There are two types of diff format; 'none' 'current', 'all', 'current.word', 'all.word'.
" 'current.word' and 'all.word' are for word diff. And 'current' and 'all' are " for unified diff.
" Define different highlights for unified diffs and word diffs.
" b:__gitmessenger_diff is set by Blame.render() in blame.vim.
if get(b:, '__gitmessenger_diff', '') =~# '\.word$'
    if has('conceal') && get(g:, 'git_messenger_conceal_word_diff_marker', v:true)
        syn region diffWordsRemoved matchgroup=Conceal start=/\[-/ end=/-]/ concealends oneline
        syn region diffWordsAdded matchgroup=Conceal start=/{+/ end=/+}/ concealends oneline
    else
        syn region diffWordsRemoved start=/\[-/ end=/-]/ oneline
        syn region diffWordsAdded start=/{+/ end=/+}/ oneline
    endif
else
    exe 'syn match diffRemoved "' . margin_pat . '-.*" contained containedin=gitDiff display'
    exe 'syn match diffAdded "' . margin_pat . '+.*" contained containedin=gitDiff display'
endif

exe 'syn match diffFile "' . margin_pat . 'diff --git .*" display'
exe 'syn match diffOldFile "' . margin_pat . '--- \(a\>.*\|/dev/null\)" display'
exe 'syn match diffNewFile "' . margin_pat . '+++ \(b\>.*\|/dev/null\)" display'
exe 'syn match diffIndexLine "' . margin_pat . 'index \x\{7,}\.\.\x\{7,}.*" display'
exe 'syn match diffLine "' . margin_pat . '@@ .*" contained containedin=gitDiff display'

exec 'syn region gitDiff start=/' .. margin_pat . '\%(@@ -\)\@=/ end=/' . margin_pat . '\%(diff --git \|$\)\@=/ contains=diffRemoved,diffAdded,diffLine'

hi def link gitmessengerHeader      Identifier
hi def link gitmessengerHash        Comment
hi def link gitmessengerHistory     Constant
hi def link gitmessengerEmail       gitmessengerPopupNormal
hi def link gitmessengerPopupNormal NormalFloat

hi def link diffOldFile      diffFile
hi def link diffNewFile      diffFile
hi def link diffIndexLine    PreProc
hi def link diffFile         Type
hi def link diffRemoved      Special
hi def link diffAdded        Identifier
hi def link diffWordsRemoved diffRemoved
hi def link diffWordsAdded   diffAdded
hi def link diffLine         Statement

let b:current_syntax = 'gitmessengerpopup'
