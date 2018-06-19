execute pathogen#infect()

filetype plugin indent on

set updatetime=100
set number cursorline hlsearch
syntax on
set smartindent autoindent tabstop=2 softtabstop=2 shiftwidth=2
set ignorecase smartcase
set clipboard=unnamed
let mapleader="-"
set tabpagemax=100
set mouse=a
set guifont=xos4\ Terminus\ 12

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
"" Select All
nnoremap <leader>a ggVG
vnoremap <leader>a <ESC>ggVG
"" Paste from system register
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
"" Copy to system register
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
vnoremap <leader>y "+y
vnoremap <leader>Y "+Y
"" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

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
\ "black": {"gui": "#051421", "cterm": "NONE", "cterm16": "NONE" },
\}
colorscheme onedark
highlight CursorLine ctermbg=0
highlight Visual ctermbg=0
highlight Search cterm=NONE ctermfg=NONE ctermbg=8

" Toggle highlight.
let hlstate=0
nnoremap <ESC><ESC> :if (hlstate%2 == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=hlstate+1<CR>

" Sessions
let g:session_dir = '~/.vim/sessions'
exec 'nnoremap <Leader>ss :mks! ' . g:session_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <Leader>sr :so ' . g:session_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'

" vimdiff highlighting
highlight DiffAdd    cterm=bold ctermfg=NONE ctermbg=22 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=NONE ctermbg=52 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=NONE ctermbg=235  gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=NONE ctermbg=8  gui=none guifg=bg guibg=Red
