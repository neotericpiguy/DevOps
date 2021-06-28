" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

call plug#begin('~/.vim/plugged')
" Plug 'ervandew/supertab'
"
" Argumentative aids with manipulating and moving between function arguments.
" 
" Shifting arguments with <, and >,
" Moving between argument boundaries with [, and ],
" New text objects a, and i,
Plug 'git://github.com/PeterRincker/vim-argumentative.git'
"Plug 'git://github.com/godlygeek/tabular.git' " Mostly use easy-align
Plug 'git://github.com/majutsushi/tagbar'
Plug 'git://github.com/tpope/vim-dispatch.git'
Plug 'git://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'Yggdroot/indentLine'
Plug 'https://github.com/benekastah/neomake.git'
Plug 'https://github.com/bling/vim-airline.git'
Plug 'https://github.com/derekwyatt/vim-fswitch.git'
Plug 'https://github.com/radenling/vim-dispatch-neovim.git'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
Plug 'https://github.com/rhysd/vim-clang-format'
"Plug 'https://github.com/kana/vim-operator-user'
"Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'https://github.com/tpope/vim-repeat.git'

"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif

call plug#end()

let g:deoplete#enable_at_startup = 1

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

filetype plugin indent on

let mapleader = "\<Space>"
nnoremap <Leader>w :wa<CR>:ClangFormat<CR>

" autocmd! BufWritePost * Neomake!

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
" autocmd QuickFixCmdPost [^l]* nested cwindow
" autocmd QuickFixCmdPost    l* nested lwindow

function! FZFExecute()
  " Remove trailing new line to make it work with tmux splits
  let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
  if !v:shell_error
   call fzf#run({'sink': 'e', 'dir': directory, 'source': 'git ls-files --recurse-submodules', 'tmux_height': '40%'})
"   call fzf#run({'sink*':  function('s:my_fzf_handler'), 'dir': directory, 'source': 'git ls-files', 'tmux_height': '40%', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v' })
  else
    FZF
  endif
endfunction
command! FZFExecute call FZFExecute()

function! AStyle()
  let l = winsaveview()
  :%! indent -linux
  call winrestview(l)
endfunction
command! FZFExecute call FZFExecute()

map <C-k> :e %:h<CR>
map <C-p> :FZFExecute<CR>
map <C-t> :Tags<CR>
map <C-b> :Buffers<CR>
map \ls :call AStyle() <CR>
map \dd :windo diffthis <CR>
map \do :windo diff off <CR>:windo set noscrollbind<CR>


set makeprg=make\ -j2

let g:airline_theme='ubaryd'

au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '../inc'
map gs :FSHere<CR>
map \refresh :source ~/.config/nvim/init.vim<CR>:PlugClean<CR>:PlugInstall<CR>
nnoremap gb :buffers<CR>:buffer<Space>

set nowrap
syntax on
set incsearch
set number
" set relativenumber
set autoindent
set nohlsearch
set cursorline

set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set cindent
set cinoptions+=g0,h2,N-s

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

nmap \ll :Make<CR>
map \lc :Make clean<CR>:Make<CR>

" set autochdir  "might be import tant for ctags
set tags+=./tags

nmap ,l :set list!<CR>

" Fugitive bindings
map \gs :Gstatus<CR>
map \gd :Gdiff 
map \gg :Ggrep 
map \ga :!git add % <CR><CR>
map \gc :Gcommit<CR>

map \dd :windo diffthis<CR>
map \do :windo diffoff<CR>

map tt :TagbarOpenAutoClose<CR>
" map <C-n> :cn<CR>
" map <C-p> :cp<CR>

hi Folded ctermbg=000
hi Folded ctermfg=216

autocmd FileType make setlocal noexpandtab
let g:tex_flavor='latex'
autocmd BufNewFile,BufRead *.scad set syntax=c

" Lambda formaterr
xmap cf :ClangFormat<CR>
let g:clang_format#style_options = {
            \ "BasedOnStyle" : "Google",
            \ "ColumnLimit" : 0,
            \ "AccessModifierOffset" : -2,
            \ "BreakConstructorInitializers" : "AfterColon",
            \ "DerivePointerAlignment" : "false",
            \ "PointerAlignment" : "Left",
            \ "BinPackArguments" : "true",
            \ "FixNamespaceComments" : "true",
            \ "MaxEmptyLinesToKeep" : 1,
            \ "AllowShortIfStatementsOnASingleLine" : "false",
            \ "AllowShortFunctionsOnASingleLine" : "None",
            \ "BreakBeforeBraces": "Custom",
            \ "BraceWrapping" : {
            \ "AfterClass": "true",
            \ "BeforeElse": "true",
            \ "AfterControlStatement": "true",
            \ "BeforeCatch": "true",
            \ "SplitEmptyFunction": "true",
            \ "SplitEmptyRecord": "true",
            \ "AfterFunction": "true"
            \}}

"Auto format
" autocmd FileType c,cpp ClangFormatAutoEnable
autocmd FileType scad ClangFormatAutoEnable

"Color stuff to help view things
set background=dark
hi Visual ctermfg=White ctermbg=LightBlue cterm=none

"Indent characters
let g:indentLine_char = '.'

nnoremap <Tab> <Esc>
vnoremap <Tab> <Esc>gV
onoremap <Tab> <Esc>
" cnoremap <Tab> <C-C><Esc>
inoremap <Tab> <Esc>`^
inoremap <Leader><Tab> <Tab>

colorscheme industry
