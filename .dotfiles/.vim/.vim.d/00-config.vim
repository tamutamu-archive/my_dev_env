" setting
"
"python3 path
"let $PATH = "~/.pyenv/shims:".$PATH
let $PYTHONPATH="/home/" . $USER . "/.pyenv/versions/vim/lib/python3.6/site-packages"

"文字コードをUFT-8に設定
scriptencoding utf-8
set encoding=utf-8
set fenc=utf-8
set fileformats=unix
set fileformat=unix
" バックアップファイルを作らない
set nobackup
set noundofile
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
set nrformats=

set backspace=indent,eol,start
set fileencodings=utf-8,iso-2022-jp-3,iso-2022-jp,euc-jisx2013,euc-jp,ucs-bom,euc-jp,eucjp-ms,cp932

set statusline=%F%m%r%h%w\%=[TYPE=%Y]\[FORMAT=%{&ff}]\[ENC=%{&fileencoding}]\[LOW=%l/%L]

" 最終行で改行されるのを抑制
set nofixeol


" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
"## set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell t_vb=
set noerrorbells
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
" Fix 0~ and 1~ problems
set t_BE=

" Tab系
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
set shiftwidth=2

" 可視化
set list  
set listchars=tab:>.,trail:␣,eol:↲,extends:>,precedes:<,nbsp:%

" 全角をハイライト
augroup highlightIdegraphicsSpace
  autocmd!
  autocmd ColorScheme * highligh IdegraphicsSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
  autocmd VimEnter,WinEnter * match IdegraphicsSpace /　/
augroup END 
colorscheme desert

" クリップボード連携
set clipboard&
set clipboard^=unnamedplus

" 編集前ファイルと編集後バッファの比較
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

nnoremap <silent> <C-d>f :<C-u>call <SID>DiffWithSaved()<CR>
