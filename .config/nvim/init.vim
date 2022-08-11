set nocompatible

if (has("termguicolors"))
 set termguicolors
endif

syntax enable

set mouse=a
set clipboard=unnamedplus
set ttyfast

set showmatch
set ignorecase
set hlsearch
set incsearch
set number
set relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set autoindent
set cc=80

" Autocompletion
set wildmenu
set wildmode=longest:full,full

" Display unprintable characters f12 - switches
set list
set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping

filetype plugin indent on

call plug#begin("~/.vim/plugged")

" Status line with Minimalistic theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Snippets
Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'

" Theme
Plug 'jacoborus/tender.vim'

" CSS color highlights
Plug 'norcalli/nvim-colorizer.lua'

"Plug 'ryanoasis/vim-devicons'
Plug 'vimwiki/vimwiki'
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-startify'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'zchee/deoplete-jedi'
Plug 'lervag/vimtex'

call plug#end()

"let g:deoplete#enable_at_startup = 1
let g:airline_theme='minimalist'
let g:airline#extensions#whitespace#enabled = 0

let g:vimwiki_list = [{
    \ 'path':'~/pCloudDrive/VimWiki', 
    \ 'path_html':'~/pCloudDrive/VimWiki/html/'
\}]

"require('colorizer').setup()

colorscheme tender
highlight Normal guibg=NONE ctermbg=NONE
