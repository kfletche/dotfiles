" vundle
filetype off 
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" vundle plugins
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

call vundle#end()
filetype plugin indent on

" set a few defaults
let python_highlight_all=1
syntax on
set nu " turn on line numbering
set nocompatible

" colors 
if has('gui_running')
  set background=light
  colorscheme solarized
else
  set background=dark
  colorscheme ir_black
endif

" clipboard in os x
set clipboard=unnamed

" open windows on right
set splitright
set splitbelow

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

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" spacing tabs for python (PEP8) et al.
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

"ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$'] 

" youcompleteme customizations
let g:ycm_autoclose_preview_window_after_completion=1 " window goes away
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR> " map goto key
