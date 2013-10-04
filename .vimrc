" colorscheme settings
syntax enable " enable syntax coloring
set background=light " dark/light
colorscheme darkburn " set colorscheme
set t_Co=256

" non-console font
set guifont=Consolas:h9:cANSI

" vimoutliner and voom settings
let &showbreak=repeat(' ', 20) " indent wrapping lines
let g:voom_ft_modes = {'otl': 'vimoutliner'} " voom set to vimoutliner by default

" indentation
set autoindent " copy indentation from previous line
set backspace=indent,eol,start " make backspace like other apps
set smartindent " sometimes inserts one extra level of indentation
"set shiftwidth=4 " indent hard tabs
"set tabstop=4 " indent hard tabs
filetype plugin indent on " enable filetype indenting
highlight MatchParen ctermbg=black " highlight matching parentheses

" filing
set nobackup " disable ~ backups
set nocompatible " disable vi
set nohidden " minimize memory
set noswapfile " disable swap files
set nowb " disable automatic write backup

" search
set ignorecase " ignore case search
set smartcase " case sensitive if pattern has uppercase
set incsearch " incremental search
set hlsearch " highlight search

" ui
set noerrorbells " disable beeping
set novisualbell " disable flashing
set showcmd " show command 

" wrapping
set linebreak " only wrap at ^I!@*-+;:,./?
set nolist " wrap at lists
set wrap " word wrapping
