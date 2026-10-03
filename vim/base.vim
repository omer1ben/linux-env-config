" Options and keybindings shared by vim and neovim.
" Keep this to plain `set`/`map` commands — no plugin config — so every
" editor that sources it can parse it.

" Set <leader> to space before any <leader> mapping below.
let mapleader=" "

" ------------     Settings     ------------

" Make vim show the background properly in tmux
set t_ut=

" Better searching
set hlsearch
set incsearch

" Show matching brackets
set showmatch
set matchpairs+=<:>

" Disable bell sound
set visualbell

" Hide closed buffers
set hidden

" Better command completion
set wildmenu

" Show line numbers
set number

" Ignore case in searches unless there is an upper char
set ignorecase
set smartcase

" Mark spell errors
set spell

" Show number of occurrences while searching at bottom right corner
set shortmess-=S

" Make backspace work properly in insert mode
set backspace=indent,eol,start

" Better line joining for comments
set formatoptions+=j

" Tab options
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent
set smartindent

" Open new split panes to right and bottom
set splitbelow
set splitright

" ------------ Keybindings ------------

" Y to copy until end of line (like C, D)
nmap Y y$

" Jump to end like shell (no <C-a> for home: it's the tmux prefix)
inoremap <C-e> <End>
noremap <C-e> $

" Delete/Change without overriding the paste register
nnoremap d "_d
nnoremap c "_c
nnoremap D "_D
nnoremap C "_C
nnoremap x "_x
nnoremap X "_X
nnoremap s "_s
nnoremap S "_S
" Delete line with paste
nnoremap <leader>d dd

" Disable the command history window
vmap q: <Nop>
nmap q: <Nop>

" Exit visual mode
vnoremap <leader>jk <Esc>

" Tabs
noremap <C-t> :tabe<space>
noremap <C-x> :tabp<CR>
noremap <C-c> :tabn<CR>

" Move between splits
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Toggle paste mode
nnoremap <leader><insert> :set paste! paste?<CR>

" Stop highlighting
nnoremap <leader>n :nohlsearch<CR>

" fzf.vim
nnoremap ,f :Files<CR>
nnoremap ,g :GitFiles<CR>
nnoremap ,l :Lines<CR>
nnoremap ,a :Ag<CR>
