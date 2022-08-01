set nocompatible
set showmatch
set ignorecase
set mouse=v
set hlsearch
set incsearch
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set number
set wildmode=longest,list
set cc=80

filetype plugin indent on
syntax on
set mouse=a
set clipboard=unnamedplus
set cursorline
set ttyfast

call plug#begin("~/.vim/plugged")

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  Plug 'dracula/vim'
  Plug 'ryanoasis/vim-devicons'
  Plug 'SirVer/ultisnips'
  "Plug 'honza/vim-snippets'
  Plug 'vimwiki/vimwiki'
  Plug 'scrooloose/nerdtree'
  Plug 'preservim/nerdcommenter'
  Plug 'mhinz/vim-startify'
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}
  "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'zchee/deoplete-jedi'
  Plug 'larvag/vimtex'
 
call plug#end()

"let g:deoplete#enable_at_startup = 1
let g:airline_theme='minimalist'
