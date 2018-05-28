execute pathogen#infect()

filetype plugin indent on

set updatetime=100
set nu
syntax on
set smartindent autoindent tabstop=2 softtabstop=2 shiftwidth=2
set ignorecase smartcase
set clipboard=unnamed
let mapleader="-"
set hls
set tabpagemax=100
set mouse=a

" Keybindings
"" Line navigation
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
nnoremap <C-a> 0
nnoremap <C-e> $
"" Tab navigation
nnoremap <C-l> :tabnext<CR>
nnoremap <C-h> :tabprev<CR>
nnoremap <C-k> :tabfirst<CR>
nnoremap <C-j> :tablast<CR>
"" NERDTree
nnoremap <C-n> :NERDTree<CR>

" Enable crontab editing in place
au BufNewFile,BufRead crontab.* set nobackup | set nowritebackup

" Set syntax for specific extensions
autocmd BufNewFile,BufRead *.env  set syntax=dosini

" Last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set laststatus=2
let g:lightline = {
\'colorscheme': 'twodark',
\}
let g:onedark_color_overrides = {
\ "black": {"gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
\}
colorscheme onedark
hi Search cterm=NONE ctermfg=NONE ctermbg=black
" Toggle highlight.
let hlstate=0
nnoremap <ESC><ESC> :if (hlstate%2 == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=hlstate+1<cr>
