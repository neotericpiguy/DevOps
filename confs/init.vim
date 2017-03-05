set nocompatible              " be iMproved, required
filetype off                  " required 

call plug#begin('~/.vim/plugged')
" Add plugins to &runtimepath
Plug 'ervandew/supertab'
Plug 'git://github.com/PeterRincker/vim-argumentative.git'
Plug 'git://github.com/godlygeek/tabular.git'
Plug 'git://github.com/majutsushi/tagbar'
Plug 'git://github.com/tpope/vim-dispatch.git'
Plug 'git://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/benekastah/neomake.git'
Plug 'https://github.com/bling/vim-airline.git'
Plug 'https://github.com/derekwyatt/vim-fswitch.git'
Plug 'https://github.com/radenling/vim-dispatch-neovim.git'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
Plug 'https://github.com/rhysd/vim-clang-format'
Plug 'https://github.com/kana/vim-operator-user'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'octol/vim-cpp-enhanced-highlight'

call plug#end()

let mapleader = "\<Space>"
nnoremap <Leader>w :w<CR>

autocmd! BufWritePost * Neomake!

function! FZFExecute()
  " Remove trailing new line to make it work with tmux splits
  let directory = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')
  if !v:shell_error
   call fzf#run({'sink': 'e', 'dir': directory, 'source': 'git ls-files', 'tmux_height': '40%'})
"   call fzf#run({'sink*':  function('s:my_fzf_handler'), 'dir': directory, 'source': 'git ls-files', 'tmux_height': '40%', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v' })
  else
    FZF
  endif
endfunction
command! FZFExecute call FZFExecute()

map <C-k> :FZFExecute<CR>

set makeprg=make\ -j`nproc`

let g:airline_theme='ubaryd'

au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '../inc'
map gs :FSHere<CR>

set nowrap
syntax on
set incsearch
set number
set relativenumber
set autoindent
set hlsearch!
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
set autochdir

nmap \ll :Make<CR>
map \lc :Make clean<CR>:Make<CR>

set autochdir  "might be import tant for ctags
set tags+=./tags;

nmap ,l :set list!<CR>

" Fugitive bindings
map \gs :Gstatus<CR>
map \gd :Gdiff HEAD^<CR>
map gca :Git commit -a --amend<CR>
map grev :Git push origin HEAD:refs/for/master<CR>

map tt :TagbarOpenAutoClose<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

hi Folded ctermbg=000
hi Folded ctermfg=216

" colorscheme preto
autocmd FileType make setlocal noexpandtab
let g:tex_flavor='latex'

" Lambda formaterr
xmap cf :ClangFormat<CR>

" vim grep
"map <C-f> :execute "vimgrep /" . expand("<cword>") . "/j **.cpp" <Bar> cw<CR>
map <C-f> :execute "vimgrep /" . expand("<cword>") . "/j `git rev-parse --show-toplevel`/**/*.cpp" <Bar> cw<CR>
"map <C-f> :execute " grep -srnw --binary-files=without-match --exclude-dir=.git . -e " . expand("<cword>") . " " <bar> cwindow<CR>

hi Search cterm=NONE ctermfg=grey ctermbg=blue

