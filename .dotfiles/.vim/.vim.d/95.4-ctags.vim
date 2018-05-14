nnoremap <f5> :call UpdateTags(getcwd())<CR>
"autocmd BufWritePost * call system("ctags -R")


function! UpdateTags(cur_dir)
    try
      call system("bash -c \"mkdir -p /var/tags" . a:cur_dir . "\"")
      call system("ctags -R -f /var/tags" . a:cur_dir . "/tags " . a:cur_dir)
    catch
      echo('ERROR')
    endtry
endfunction


function! ReadTags(cur_dir)
    try
      execute "set tags=/var/tags" . a:cur_dir . "/tags"
    catch
      echo('ERROR')
    endtry
endfunction

augroup TagsAutoCmd
    autocmd!
    ""autocmd BufEnter * :call ReadTags(expand("%:p:h"))
    autocmd BufEnter * :call ReadTags(getcwd())
augroup END
