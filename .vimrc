" ======= Initial Setup ======= "

filetype off
filetype plugin indent on

" Vim-plug plugins
call plug#begin('~/.vim/plugged')

" Code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'ternjs/tern_for_vim', { 'do': 'yarn install' }
"Plug 'w0rp/ale'                       " linting

" Snippits & Tabs
Plug 'SirVer/ultisnips'               " snippets manager
Plug 'honza/vim-snippets'             " snippets library
"Plug 'ervandew/supertab'

" Python
Plug 'vim-scripts/indentpython.vim'   " fixes indentation
Plug 'nvie/vim-flake8'                " PEP8 checking
Plug 'tmhedberg/SimpylFold'           " proper folding for python

" Search / Navigation
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "search
" Plug 'ctrlpvim/ctrlp.vim'           " search
" Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'

" Diff/Git
Plug 'vim-scripts/DirDiff.vim'        " recursive directory diffs
Plug 'tpope/vim-fugitive'             " git support

" Statusline
Plug 'itchyny/lightline.vim'
"Plug 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

" Markdown
Plug 'godlygeek/tabular'              " for markdown formatting
Plug 'plasticboy/vim-markdown'        " markdown formatting
Plug 'jamessan/vim-gnupg'             " pgp support

" Colors
Plug 'twerth/ir_black'                " colorscheme
"Plug 'altercation/vim-colors-solarized' " colorscheme
"Plug 'Lokaltog/vim-distinguished'" colorscheme
""Plug 'xolox/vim-misc' " delete with colorscheme-switcher
"Plug 'xolox/vim-colorscheme-switcher' " cycle though vim themes with F8

" Misc
Plug 'reedes/vim-pencil'              " writing mode
Plug 'christoomey/vim-tmux-navigator'
"Plug 'benmills/vimux'                 " tmux/vim integration
Plug 'tpope/vim-obsession'            " save vim to disk
Plug 'tpope/vim-commentary'           " better commenting

call plug#end()

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

"" Switch colorschemes quickly
"call togglebg#map("<F5>")

" ======= Navication Shortcuts======= "

" resize current windows
nnoremap <C-left> <C-W><
nnoremap <C-down> <C-W>-
nnoremap <C-up> <C-W>+
nnoremap <C-right> <C-W>>

" ======= Options ======= "

syntax on
set encoding=utf-8

set hidden " for coc
set number " turn on line numbering
set nocompatible

" for coc
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=number

" colors
if has('gui_running')
  set background=light
  colorscheme solarized
  if has('gui_macvim')
    set guifont=Inconsolata\ for\ Powerline:h16
  else
    set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 12
  endif
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
set showmode " show VISUAL at bottom
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

set foldenable
set foldlevel=1

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
"let NERDTreeIgnore=['\.pyc$', '\~$']

" ======= Utility Customizations ======= "

" Supertab and UtilSnips
let g:UltiSnipsExpandTrigger="<C-j>"

" ======= Plugin Options ======= "

" CoC
"
nmap <leader>d <Plug>(coc-format-selected)
nmap ]g <Plug>(coc-diagnostic-next)
nmap [g <Plug>(coc-diagnostic-prev)

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

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)


augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
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



let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-json',
  \ 'coc-css',
  \ 'coc-html',
  \ ]

let g:coc_user_config = {
  \ "prettier.eslintIntegration": v:true,
  \ "codeLens.enable": v:true,
  \ 'suggest': {
  \   'enablePreview': v:true,
  \   'floatEnable': v:true,
  \   'maxCompleteItemCount': 48,
  \   'minTriggerInputLength': 2,
  \   'noselect': v:false,
  \   'preferCompleteThanJumpPlaceholder': v:true,
  \   'timeout': 500,
  \   'triggerAfterInsertEnter': v:true,
  \ },
  \ 'diagnostic': {
  \   'errorSign': '✘',
  \   'warningSign': '⚠',
  \   'infoSign': '',
  \   'hintSign': 'ஐ',
  \ },
  \ 'diagnostic-languageserver.filetypes': {
  \   'vim': 'vint',
  \   'sh': 'shellcheck',
  \   'html': ['tidy'],
  \   'javascript': ['eslint'],
  \   'typescript': ['tslint']
  \  },
  \ 'coc.preferences.formatOnSaveFiletypes': [
  \   'javascript',
  \   'javascriptreact',
  \   'typescript',
  \   'typescriptreact',
  \   'typescript.tsx',
  \   'html',
  \   'json',
  \   'graphql',
  \ ],
  \ 'prettier.disableSuccessMessage': v:true,
  \ 'css.lint':  {
  \   'duplicateProperties': 'warning',
  \   'float': 'warning',
  \ },
\ }




"" Ale
"let g:ale_fixers = {
"\   'javascript': ['eslint'],
"\   'html': ['prettier']
"\ }
"nmap <leader>d <Plug>(ale_fix)

"" YouCompleteMe
"let g:ycm_python_binary_path = '/usr/local/bin/python3'
"let g:ycm_autoclose_preview_window_after_completion=1 " window goes away
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR> " map goto key

" Vimux
let VimuxUseNearestPane = 1
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"

" Netrw
let g:netrw_banner = 0
let g:netrw_bufsettings = 'noma nomod nu nowrap ro nobl'

" vim-markdown
"let g:vim_markdown_folding_disabled=1

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
