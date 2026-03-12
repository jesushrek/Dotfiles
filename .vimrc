call plug#begin()
Plug 'ap/vim-css-color'
Plug 'lervag/vimtex'
call plug#end()

set t_Co=16

filetype plugin on 
filetype plugin indent on

set hlsearch
set ignorecase 
set rnu

syntax on
set tabstop=4

set complete+=i
set path+=/usr/local/include/
set path+=/usr/include/c++/**
set tagbsearch

setlocal tabstop=4 shiftwidth=4 expandtab

autocmd FileType tex nnoremap <buffer> <F5> :w<CR>:!pdflatex %<CR>

autocmd FileType c nnoremap <buffer> <F5> :w<CR>:!gcc -o %< % -Werror -Wall && ./%<<CR>
autocmd FileType cpp nnoremap <buffer> <F5> :w<CR>:!g++ -o %< % -Werror -Wall&& ./%<<CR>

let mapleader = ' '
nmap <F3> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
