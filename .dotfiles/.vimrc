if &compatible
   set nocompatible
endif

filetype plugin indent on
syntax enable


"Include .vim.d 
runtime! .vim.d/*.vim

set clipboard&
set clipboard^=unnamedplus
