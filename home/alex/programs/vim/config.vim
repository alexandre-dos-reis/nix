filetype plugin indent on
syntax on
set autoindent
set backspace=indent,eol,start
set hidden
set hlsearch
set laststatus=2
set noshowmode
set mouse=a
set noundofile
set number
set wildmenu
set autochdir
set noswapfile
set background=dark 
set number relativenumber

hi StatusLine ctermfg=8 ctermbg=NONE cterm=NONE

let mapleader = " "

" recenter screen on page up and down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" recenter screen on search
nnoremap n nzzzv
nnoremap N Nzzzv

" Ref: https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/
nnoremap <leader>e :Explore<CR>

function! NetrwMapping()
 nmap <buffer> h -^                       " go one dir up
 nmap <buffer> . gh                       " toggle hidden files
 nmap <Esc> :Rex<CR>                      " Quit
 nmap <buffer> c %:w<CR>:buffer #<CR>     " Create file
 nmap <buffer> r R                        " Rename file
 nmap <buffer> y mc                       " Copy marked files
 nmap <buffer> m mm                       " Moved marked files
endfunction

augroup netrw_mapping
 autocmd!
 autocmd filetype netrw call NetrwMapping()
augroup END
