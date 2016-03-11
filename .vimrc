" ======= Initial Setup ======= "

filetype off
filetype plugin indent on

" Vundle plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-scripts/indentpython.vim' " fixes indentation
Plugin 'vim-scripts/DirDiff.vim' " recursive directory diffs
Plugin 'Valloric/YouCompleteMe' " autocompletion
Plugin 'scrooloose/syntastic' " syntax checking
Plugin 'nvie/vim-flake8' " PEP8 checking
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim' " search
Plugin 'tpope/vim-fugitive' " git support
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'godlygeek/tabular' " for markdown formatting
Plugin 'plasticboy/vim-markdown' " markdown formatting
Plugin 'jamessan/vim-gnupg' " pgp support
Plugin 'altercation/vim-colors-solarized' " colorscheme
Plugin 'twerth/ir_black' " colorscheme
Plugin 'tpope/vim-rails' " rails tools
Plugin 'Lokaltog/vim-distinguished' " colorscheme
Plugin 'reedes/vim-pencil' " writing mode
Plugin 'benmills/vimux' " tmux/vim integration
Plugin 'tmhedberg/SimpylFold' " proper folding for python

call vundle#end()

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red


" ======= Navication Shortcuts======= "

" resize current windows
nnoremap <C-left> <C-W><
nnoremap <C-down> <C-W>-
nnoremap <C-up> <C-W>+
nnoremap <C-right> <C-W>>


" ======= Options ======= "

syntax on
set encoding=utf-8

set number " turn on line numbering
set nocompatible

" colors
if has('gui_running')
  set background=light
  colorscheme solarized
  set guifont=Inconsolata\ for\ Powerline:h16
else
  set background=dark
  colorscheme ir_black
  "colorscheme distinguished
endif

" clipboard in os x
set clipboard=unnamed

" open windows on right
set splitright
set splitbelow

set scrolloff=3 " when to start scrolling
set noshowmode " hide VISUAL at bottom
set nopaste " turn off autoindent when pasting
set wildmenu " show potential completions
set wildignore+=*.o,*.obj,.git,*.pyc,.DS_Store
set smartcase " don't look for case in lowercase searches
set ruler " text after double quote a comment
set ttyfast " assume fast terminal, improves redraw
set backspace=indent,eol,start " make backspace work over eol etc.
set laststatus=2 " always show statusline
set t_Co=256 " force 256 colors
"set showbreak=↪

" Spaces/Tab
set autoindent
set expandtab " set up spaces as tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround  " when at 3 spaces, and I hit > ... go to 4, not 5
set smarttab
set smartindent " indent based on the previous line

" backup to ~/.tmp
set nobackup
set nowritebackup
set noswapfile

" ======= Writing Options ======= "

" markdown folding
nnoremap <Space> za
let g:markdown_fold_style = 'nested'

" word processing mode for writing
func! WordProcessorMode()
  setlocal formatoptions=1
  setlocal noexpandtab
  map j gj
  map k gk
  setlocal spell spelllang=en_us
  set thesaurus+=/Users/sbrown/.vim/thesaurus/mthesaur.txt
  set complete+=s
  set formatprg=par
  setlocal wrap
  setlocal linebreak
endfu
com! WP call WordProcessorMode()

" automatically set paste mode for pasting
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" auto set paste mode for pasting in tmux
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif
  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"
  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")


" ======= Coding Shortcuts ======= "

" spacing tabs for python (PEP8) et al.
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set fileformat=unix |

" ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$']

" youcompleteme customizations
let g:ycm_autoclose_preview_window_after_completion=1 " window goes away
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR> " map goto key


" ======= Utility Customizations ======= "

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>


" ======= Plugin Optins ======= "

" Vimux
let VimuxUseNearestPane = 1
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"

" Netrw
let g:netrw_banner = 0
let g:netrw_bufsettings = 'noma nomod nu nowrap ro nobl'

" vim-markdown
let g:vim_markdown_folding_disabled=1

" SimpylFold
let g:SimpylFold_docstring_preview=1

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <C-w>z :ZoomToggle<CR>
