nnoremap [denite] <Nop>
nmap <C-u> [denite]



nnoremap <silent> [denite]g  :<C-u>Denite grep -buffer-name=search-buffer-denite<CR>

" Denite grep検索結果を再表示する
nnoremap <silent> [denite]r :<C-u>Denite -resume -buffer-name=search-buffer-denite<CR>
" resumeした検索結果の次の行の結果へ飛ぶ
nnoremap <silent> [denite]n :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=+1 -immediately<CR>
" resumeした検索結果の前の行の結果へ飛ぶ
nnoremap <silent> [denite]p :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=-1 -immediately<CR>


nnoremap <silent> [denite]b :Denite buffer<CR>
"nnoremap <silent> [denite]c :Denite changes<CR>
nnoremap <silent> [denite]f :Denite file_rec<CR>
"nnoremap <silent> [denite]r :<C-u>Denite -resume<CR>
"nnoremap <silent> [denite]h :Denite help<CR>
"nnoremap <silent> [denite]h :Denite help<CR>
"nnoremap <silent> [denite]l :Denite line<CR>
"nnoremap <silent> [denite]t :Denite tag<CR>
nnoremap <silent> [denite]m :Denite file_mru<CR>
"nnoremap <silent> [denite]u :Denite menu<CR>
