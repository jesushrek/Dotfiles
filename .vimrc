" All the plugins
call plug#begin()
Plug 'gko/vim-coloresque'
Plug 'dylanaraps/wal.vim'
call plug#end()

" Global settings
filetype plugin on 
filetype plugin indent on
syntax on

set t_Co=16
colorscheme wal

set hlsearch
set ignorecase 
set rnu
set tabstop=4

set complete+=i
set path+=/usr/local/include/
set path+=/usr/include/c++/**
set tagbsearch

setlocal tabstop=4 shiftwidth=4 expandtab

let mapleader = ' '
nmap <F3> i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>

autocmd FileType tex autocmd BufWritePost <buffer> silent! !pdflatex % > /dev/null 2>&1 &

" Set Background
if filereadable(expand('~/.vim.mode'))
    source ~/.vim.mode
endif
