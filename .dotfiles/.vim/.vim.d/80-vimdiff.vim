augroup vimdiffHighlight
autocmd!
autocmd ColorScheme * highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
autocmd ColorScheme * highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
autocmd ColorScheme * highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
autocmd ColorScheme * highlight DiffText   cterm=bold ctermfg=10 ctermbg=21
augroup END 
