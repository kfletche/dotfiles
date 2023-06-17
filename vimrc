" ====== Initial Setup ======= "

"---------------------
" Plugin installation
"---------------------

" Vim-plug plugins
call plug#begin('~/.vim/plugged')

" Code Completion & references
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'

" Neovim
Plug 'nvim-tree/nvim-tree.lua'

" Linting
"Plug 'dense-analysis/ale'             " faster linting than coc

" Formatting can get these from coc
"Plug 'nvie/vim-flake8'                " PEP8 checking
Plug 'psf/black'                      " Black code formatting

" Snippits & Tabs
Plug 'SirVer/ultisnips'               " snippets manager
Plug 'honza/vim-snippets'             " snippets library
"Plug 'ervandew/supertab'

" Python

Plug 'tmhedberg/SimpylFold'                           " proper folding for python
"Plug 'vim-scripts/indentpython.vim'                  " fixes indentation
" Plug 'jpalardy/vim-slime', { 'for': 'python' }        " ipython integration
" Plug 'hanschen/vim-ipython-cell', { 'for': 'python' } " ipython integration


" Search / Navigation
" Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
"Plug 'ctrlpvim/ctrlp.vim'                                         " search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " search
Plug 'easymotion/vim-easymotion'

" Diff/Git
Plug 'tpope/vim-fugitive'             " git support
Plug 'vim-scripts/DirDiff.vim'        " recursive directory diffs

" Statusline
Plug 'itchyny/lightline.vim'
"Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

" Markdown
Plug 'plasticboy/vim-markdown'        " markdown formatting
Plug 'godlygeek/tabular'              " to align tables etc

" Colors
Plug 'altercation/vim-colors-solarized' " colorscheme
Plug 'twerth/ir_black'                  " colorscheme
Plug 'morhetz/gruvbox'
Plug 'tomasiser/vim-code-dark'
Plug 'jeffkreeftmeijer/vim-dim'
Plug 'ayu-theme/ayu-vim'

"Plug 'Lokaltog/vim-distinguished'" colorscheme
"Plug 'xolox/vim-misc' " delete with colorscheme-switcher
"Plug 'xolox/vim-colorscheme-switcher' " cycle though vim themes with F8

" Misc
Plug 'reedes/vim-pencil'              " writing mode
Plug 'christoomey/vim-tmux-navigator' " tmux integration
Plug 'tpope/vim-surround'             " quickly surround objects
Plug 'tpope/vim-obsession'            " save vim to disk
Plug 'tpope/vim-commentary'           " better commenting
Plug 'suy/vim-context-commentstring'  " even nicer jsx commentary
Plug 'maxmellon/vim-jsx-pretty'       " even nicer jsx commentary
Plug 'jamessan/vim-gnupg'             " pgp support

call plug#end()


"---------------------
" Basic editing config
"---------------------

set shortmess+=I " disable startup message
set number " turn on line numbering
set relativenumber " relative line numbering
set nocompatible
set hidden " allow auto-hiding of edited buffers
set incsearch " incremental search (as string is being typed)
set hls " highlight search
set scrolloff=5 " show lines above and below cursor (when possible)
set linebreak " prevent line breaks in middle of words
set noshowmode " hide --INSERT-- in the bar
set laststatus=2 " always display the status line
set backspace=indent,eol,start " make backspace work over everything
set timeout timeoutlen=1000 ttimeoutlen=100 " fix slow O inserts
set lazyredraw " skip redrawing screen in some cases
set autochdir " automatically set current directory to directory of last opened file
set history=8192 " more history
set nojoinspaces " suppress inserting two spaces between sentences
set mouse+=a " enable mouse mode (scrolling, selection, etc)
set nofoldenable " disable folding
set foldmethod=syntax " fold based on syntax
set foldlevel=1
set noerrorbells visualbell t_vb= " disable audible bell
set splitbelow " open new split panes below
set splitright " open split panes to the right
set clipboard=unnamed " share clipboard with system
set nopaste " turn off autoindent when pasting

set ruler " text after double quote a comment
set ttyfast " assume fast terminal, improves redraw

" no backup creation
set nobackup
set nowritebackup
set noswapfile " no swapfile creation

" spaces/tab
set autoindent
set expandtab " set up spaces as tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround  " when at 3 spaces, and I hit > ... go to 4, not 5
set smarttab
set smartindent " indent based on the previous line

" smart case-sensitive search
set ignorecase
set smartcase " don't look for case in lowercase searches

" tab completion for files/buffers
set wildmode=longest,list
set wildmenu " show potential completions
set wildignore+=*.o,*.obj,.git,*.pyc,.DS_Store

" unbind keys
map <C-a> <Nop>
map <C-x> <Nop>
nmap Q <Nop>

" save read-only files
command -nargs=0 Sudow w !sudo tee % >/dev/null

"--------------------
" Movement and resize
"--------------------

" quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" resize current windows
nnoremap <C-left> <C-W><
nnoremap <C-down> <C-W>-
nnoremap <C-up> <C-W>+
nnoremap <C-right> <C-W>>

" zoom and restore window
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

" movement relative to display lines
nnoremap <silent> <Leader>d :call ToggleMovementByDisplayLines()<CR>
function SetMovementByDisplayLines()
    noremap <buffer> <silent> <expr> k v:count ? 'k' : 'gk'
    noremap <buffer> <silent> <expr> j v:count ? 'j' : 'gj'
    noremap <buffer> <silent> 0 g0
    noremap <buffer> <silent> $ g$
endfunction
function ToggleMovementByDisplayLines()
    if !exists('b:movement_by_display_lines')
        let b:movement_by_display_lines = 0
    endif
    if b:movement_by_display_lines
        let b:movement_by_display_lines = 0
        silent! nunmap <buffer> k
        silent! nunmap <buffer> j
        silent! nunmap <buffer> 0
        silent! nunmap <buffer> $
    else
        let b:movement_by_display_lines = 1
        call SetMovementByDisplayLines()
    endif
endfunction

" toggle relative numbering
nnoremap <C-n> :set rnu!<CR>


"------------------
" Syntax and indent
"------------------

syntax on
set encoding=utf-8

filetype plugin indent on " enable file type detection
set autoindent

" highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" vim can autodetect this based on $TERM (e.g. 'xterm-256color')
" but it can be set to force 256 colors
" set t_Co=256
if has('gui_running')
    colorscheme solarized
    let g:lightline = {'colorscheme': 'solarized'}
elseif &t_Co < 256
    colorscheme default
    set nocursorline " looks bad in this mode
else
    set background=dark
    let g:solarized_termcolors=256 " instead of 16 color with mapping in terminal
    "colorscheme solarized
    colorscheme ir_black
    " customized colors
    highlight SignColumn ctermbg=234
    highlight StatusLine cterm=bold ctermfg=245 ctermbg=235
    highlight StatusLineNC cterm=bold ctermfg=245 ctermbg=235
    "let g:lightline = {'colorscheme': 'dark'}
    highlight SpellBad cterm=underline
    " patches
    highlight CursorLineNr cterm=NONE
endif

" if has('gui_running')
"   set background=light
"   colorscheme solarized
"   if has('gui_macvim')
"     set guifont=Inconsolata\ for\ Powerline:h16
"   else
"     set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12
"   endif
" else
"   set background=dark
"   if filereadable( expand("$HOME/.vim/colors/ir_black.vim") )
"         colorscheme ir_black
"   endif
"   "colorscheme gruvbox
"   "colorscheme codedark
"   " set termguicolors     " enable true colors support
"   " let ayucolor="light"  " for light version of theme
"   " let ayucolor="mirage" " for mirage version of theme
"   " let ayucolor="dark"   " for dark version of theme
"   " colorscheme ayu
"   "let g:airline_theme='codedark'
" endif

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

"" Switch colorschemes quickly
"call togglebg#map("<F5>")


"---------------------
" Plugin configuration
"---------------------

" Ale
"let g:ale_fixers = {
"\   'javascript': ['eslint'],
"\   'python': ['pylint'],
"\   'html': ['prettier'],
"\   'css': ['prettier']
"\ }
"nmap <leader>d <Plug>(ale_fix)

" nerdtree
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] " ignore files in NERDTree

" gundo
nnoremap <leader>u :gundotoggle<cr>
if has('python3')
    let g:gundo_prefer_python3 = 1
endif

"  ctrlp
"nnoremap ; :CtrlPBuffer<CR>
"let g:ctrlp_switch_buffer = 0
"let g:ctrlp_show_hidden = 1

" easymotion
map <Space> <Plug>(easymotion-prefix)

" argwrap
nnoremap <Leader>w :ArgWrap<CR>

" fugitive
set tags^=.git/tags;~

" simpylfold
let g:SimpylFold_docstring_preview=1

" UtilSnips
let g:UltiSnipsExpandTrigger="<C-j>"


" ======= Writing Options ======= "

" markdown folding
nnoremap <Space> za
" markdown
let g:markdown_fenced_languages = [
    \ 'bash=sh',
    \ 'c',
    \ 'coffee',
    \ 'erb=eruby',
    \ 'javascript',
    \ 'json',
    \ 'perl',
    \ 'python',
    \ 'ruby',
    \ 'yaml',
    \ 'go',
    \ 'racket',
    \ 'haskell',
    \ 'rust',
\]
let g:markdown_syntax_conceal = 0
let g:markdown_folding = 1
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



" ======= Plugin Options ======= "

" CoC

set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=number

let g:coc_global_extensions = [
  \ "coc-snippets",
  \ "coc-pairs",
  \ "coc-tsserver",
  \ "coc-eslint",
  \ "coc-pyright",
  \ "coc-json",
  \ "coc-css",
  \ "coc-html",
  \ "coc-prettier",
  \ ]

let g:coc_user_config = {
  \ "codeLens.enable": v:true,
  \ "eslint.filetypes": [
  \     "javascript",
  \     "typescript",
  \     "typescriptreact",
  \     "javascriptreact"
  \ ],
  \ "eslint.options" : {
  \     "env": {
  \         "browser": v:true,
  \         "node": v:true
  \     }
  \ },
  \ "eslint.autoFixOnSave": v:true,
  \ "diagnostic": {
  \   "errorSign": "✘",
  \   "warningSign": "⚠",
  \   "infoSign": "'",
  \   "hintSign": "ஐ",
  \ },
  \ "coc.preferences.formatOnType": v:true,
  \ "python.linting.pylintEnabled": v:true,
  \ "python.formatting": {
  \    "provider": "black",
  \    "blackArgs": ["--diff", "--quiet", "--fast"]
  \ },
  \ "diagnostic-languageserver.filetypes": {
  \   "vim": "vint",
  \   "sh": "shellcheck",
  \   "html": ["tidy"],
  \   "javascript": ["eslint"],
  \   "typescript": ["tslint"]
  \  },
  \ "coc.preferences.formatOnSaveFiletypes": [
  \   "javascript",
  \   "python",
  \   "json",
  \   "graphql",
  \ ],
  \ "prettier.disableSuccessMessage": v:true,
  \ "css.lint":  {
  \   "duplicateProperties": "warning",
  \   "float": "warning",
  \ }
  \ }

"nmap <leader>d  <Plug>(coc-codeaction)
nmap <leader>d :CocCommand eslint.executeAutofix<cr>
nmap gn <Plug>(coc-diagnostic-next)
nmap gp <Plug>(coc-diagnostic-prev)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" CoC snippets with tab
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Use enter to accept snippet expansion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" prettier manual shortcut
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType javascript setl formatexpr=CocCommand('eslint.executeAutofix')
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" " slime configuration (for ipython integration)

" " always use tmux
" let g:slime_target = 'tmux'

" " fix paste issues in ipython
" let g:slime_python_ipython = 1

" " always send text to the top-right pane in the current tmux tab without asking
" let g:slime_default_config = {
"             \ 'socket_name': get(split($TMUX, ','), 0),
"             \ 'target_pane': '{top-right}' }
" let g:slime_dont_ask_default = 1

" " ipython-cell configuration

" " map <Leader>s to start IPython
" nnoremap <Leader>s :SlimeSend1 ipython --matplotlib<CR>

" " map <Leader>r to run script
" nnoremap <Leader>r :IPythonCellRun<CR>

" " map <Leader>R to run script and time the execution
" nnoremap <Leader>R :IPythonCellRunTime<CR>

" " map <Leader>c to execute the current cell
" nnoremap <Leader>c :IPythonCellExecuteCell<CR>

" " map <Leader>C to execute the current cell and jump to the next cell
" nnoremap <Leader>C :IPythonCellExecuteCellJump<CR>

" " map <Leader>l to clear IPython screen
" nnoremap <Leader>l :IPythonCellClear<CR>

" " map <Leader>x to close all Matplotlib figure windows
" nnoremap <Leader>x :IPythonCellClose<CR>

" " map [c and ]c to jump to the previous and next cell header
" nnoremap [c :IPythonCellPrevCell<CR>
" nnoremap ]c :IPythonCellNextCell<CR>

" " map <Leader>h to send the current line or current selection to IPython
" nmap <Leader>h <Plug>SlimeLineSend
" xmap <Leader>h <Plug>SlimeRegionSend

" " map <Leader>p to run the previous command
" nnoremap <Leader>p :IPythonCellPrevCommand<CR>

" " map <Leader>Q to restart ipython
" nnoremap <Leader>Q :IPythonCellRestart<CR>

" " map <Leader>d to start debug mode
" " nnoremap <Leader>d :SlimeSend1 %debug<CR>

" " map <Leader>q to exit debug mode or IPython
" nnoremap <Leader>q :SlimeSend1 exit<CR>

" " map <F9> and <F10> to insert a cell header tag above/below and enter insert mode
" nmap <F9> :IPythonCellInsertAbove<CR>a
" nmap <F10> :IPythonCellInsertBelow<CR>a

" " also make <F9> and <F10> work in insert mode
" imap <F9> <C-o>:IPythonCellInsertAbove<CR>
" imap <F10> <C-o>:IPythonCellInsertBelow<CR>

