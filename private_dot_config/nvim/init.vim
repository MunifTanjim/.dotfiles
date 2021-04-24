" vim: set foldmethod=expr foldlevel=0 nomodeline :

" use different directories for vim and neovim
let cache_dir  = has('nvim') ? stdpath('cache') : expand('~/.cache/vim' )
let config_dir = has('nvim') ? stdpath('config') : expand('~/.vim')
let data_dir   = has('nvim') ? stdpath('data') : expand('~/.local/share/vim')

" other directories
let fzf_root = fnamemodify(data_dir, ':h') . '/fzf'

"# General Settings
set exrc
set hidden
set modeline
set modelines=2
set nomodelineexpr
set secure

set encoding=utf-8
set softtabstop=2
set shiftwidth=2
set expandtab

set incsearch
set ignorecase
set smartcase
set wildmenu

set nostartofline
set splitbelow
set splitright
set lazyredraw
set updatetime=1000

set clipboard=unnamed

set mouse=a

let &backupdir = data_dir . '/backup//,.'
let &directory = data_dir . '/swap//,.'
if has('persistent_undo')
  let &undodir = data_dir . '/undo//,.'
  set undofile
endif

" <Leader> and <LocalLeader>
let mapleader = "\<Space>"
let maplocalleader = "\\"

"# General Keymaps

nnoremap <Leader>q :qa<CR>

" beginning/end of line
nnoremap B ^
nnoremap E $
onoremap B ^
onoremap E $
xnoremap B ^
xnoremap E $

" disable Ctrl-a on screen/tmux
if $TERM =~ 'screen\|tmux'
  nnoremap <C-a>         <Nop>
  nnoremap <Leader><C-a> <C-a>
endif

" save
nnoremap <Leader>s :update<CR>
nnoremap <Leader>js :noa update<CR>

" " exit insert mode (caps_lock is the new escape)
" inoremap jk <Esc>
" inoremap kj <Esc>

" move lines
inoremap <M-j> <Esc>:move .+1<CR>==gi
inoremap <M-k> <Esc>:move .-2<CR>==gi
nnoremap <M-j> :move .+1<CR>==
nnoremap <M-k> :move .-2<CR>==
vnoremap <M-j> :move '>+1<CR>gv=gv
vnoremap <M-k> :move '<-2<CR>gv=gv

" yank from the cursor position to the end of the line
nnoremap Y y$
" yank/paste with system clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>Y "+y$
vnoremap <Leader>Y "+y$
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P

" make new split
nnoremap <C-w>- :new<CR>
nnoremap <C-w>\ :vnew<CR>

"" show documentation
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '. expand('<cword>')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

"# FileType Specific Settings

"## FileType: help

augroup help_custom_setting
  autocmd!
  autocmd FileType help nmap <buffer> gq :quit<CR>
augroup END

"## FileType: json

autocmd BufNewFile,BufRead tsconfig*.json setlocal filetype=jsonc
autocmd FileType jsonc syntax match Comment +\/\/.\+$+

"## FileType: tmux

autocmd FileType tmux nnoremap <silent><buffer> K :call tmux#man()<CR>

"## FileType: vim

autocmd FileType vim set foldexpr=VimFolds(v:lnum)

function! VimFolds(lnum)
  let s:cur_line = getline(a:lnum)
  if s:cur_line =~ '^"#'
    return '>' . (matchend(s:cur_line, '"#*') - 1)
  else
    return '='
  endif
endfunction

"# Plugins

" install vim-plug automagically
let plug_path = (has('nvim') ? data_dir : config_dir) . '/autoload/plug.vim'
if empty(glob(plug_path))
  silent execute '!curl -fLo ' . plug_path . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugged')

Plug 'junegunn/vim-plug'

" appearance
" Plug 'morhetz/gruvbox'
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'

" functionality
if isdirectory(fzf_root)
  Plug fzf_root
  Plug 'junegunn/fzf.vim'
  Plug 'stsewd/fzf-checkout.vim'
endif
Plug 'bkad/CamelCaseMotion'
Plug 'heavenshell/vim-jsdoc', { 'for': ['javascript', 'javascriptreact'], 'do': 'make install' }
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-startify'
Plug 'puremourning/vimspector'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'szw/vim-maximizer'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" integration
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'rhysd/git-messenger.vim'
Plug 'RyanMillerC/better-vim-tmux-resizer'
Plug 'tpope/vim-fugitive'
Plug 'wakatime/vim-wakatime'

" language support
Plug 'bronzehedwick/msmtp-syntax.vim'
Plug 'cespare/vim-toml'
Plug 'chunkhang/vim-mbsync'
Plug 'digitaltoad/vim-pug'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': ['go'] }
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jparise/vim-graphql'
Plug 'jxnblk/vim-mdx-js'
Plug 'lifepillar/pgsql.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'mustache/vim-mustache-handlebars'
Plug 'neoclide/jsonc.vim'
Plug 'neomutt/neomutt.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-git'
Plug 'tpope/vim-markdown'
Plug 'vitalk/vim-shebang'
Plug 'zinit-zsh/zinit-vim-syntax'

if has('nvim')
  Plug 'folke/lsp-colors.nvim'
  Plug 'folke/trouble.nvim'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'hrsh7th/nvim-compe'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'MunifTanjim/eslint.nvim'
  Plug 'MunifTanjim/prettier.nvim'
  Plug '~/.local/share/nvim/plugged/nui.nvim'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-treesitter/playground'
  Plug 'windwp/nvim-ts-autotag'
else
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
endif

call plug#end()

"# Plugin Settings

"## Plugin: camelcasemotion

map    <silent> <M-w>     <Plug>CamelCaseMotion_w
map    <silent> <M-b>     <Plug>CamelCaseMotion_b
map    <silent> <M-e>     <Plug>CamelCaseMotion_e
map    <silent> g<M-e>    <Plug>CamelCaseMotion_ge
sunmap <M-w>
sunmap <M-b>
sunmap <M-e>
sunmap g<M-e>
imap   <silent> <S-Left>  <C-o><Plug>CamelCaseMotion_b
imap   <silent> <S-Right> <C-o><Plug>CamelCaseMotion_w

"## Plugin: carbon-now-sh
let g:carbon_now_sh_options = {
      \ 'bg': '#8f3f71',
      \ 'ln': 'true',
      \ 'fm': 'JetBrains Mono',
      \ 'wc': 'false',
      \ 't': 'monokai' }

"## Plugin: coc

if !has('nvim')

let g:coc_global_extensions = [
      \ 'coc-actions',
      \ 'coc-css',
      \ 'coc-emoji',
      \ 'coc-explorer',
      \ 'coc-eslint',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-marketplace',
      \ 'coc-prettier',
      \ 'coc-pyright',
      \ 'coc-rls',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ ]

"### coc: commands

" command: Fold
command! -nargs=? Fold     :call CocAction('fold', <f-args>)
" command: Format
command! -nargs=0 Format   :call CocAction('format')
" command: OI
command! -nargs=0 OI       :call CocActionAsync('runCommand', 'editor.action.organizeImport')
" command: Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"### coc: functions

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '. expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction

"### coc: keymaps

"" trigger autocomplete popup menu
inoremap <silent><expr> <C-Space> coc#refresh()
"" highlight next/prev popup menu item
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"" select popup-menu item
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
"" function text object
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
"" class text object
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
"" code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"" diagnostics navigation
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
"" apply code action to current line
nmap <Leader>ac <Plug>(coc-codeaction-line)
"" apply autofix to problem on the current line
nmap <Leader>qf  <Plug>(coc-fix-current)
"" rename symbol
nmap <Leader>rn <Plug>(coc-rename)
"" format code
xmap <Leader>f <Plug>(coc-format-selected)
nmap <Leader>f <Plug>(coc-format-selected)
"" selection range
nmap <silent> <Leader>v <Plug>(coc-range-select)
xmap <silent> <Leader>v <Plug>(coc-range-select)
" "" list diagnostics
" nnoremap <silent> <Leader>ld  :<C-u>CocList diagnostics<cr>
" "" list extensions
" nnoremap <silent> <Leader>le  :<C-u>CocList extensions<cr>
" "" list commands
" nnoremap <silent> <Leader>lc  :<C-u>CocList commands<cr>
" "" list outline - symbols from current buffer
" nnoremap <silent> <Leader>lo  :<C-u>CocList outline<cr>
" "" list symbols - from workspace
" nnoremap <silent> <Leader>ls  :<C-u>CocList -I symbols<cr>
" "" list: do default action for next item in last list
" nnoremap <silent> <Leader>lj  :<C-u>CocNext<CR>
" "" list: do default action for prev item in last list
" nnoremap <silent> <Leader>lk  :<C-u>CocPrev<CR>
" "" list: reopen last list
" nnoremap <silent> <Leader>lp  :<C-u>CocListResume<CR>
"" open explorer
nmap <silent> <Space>e :CocCommand explorer<CR>

"### coc: autocommands
augroup coc_augroup
  autocmd!
  " highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " set formatexpr for specific filetypes
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact,json,graphql
        \ setlocal formatexpr=CocAction('formatSelected')
  " show signature help after jumping to a placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " keymap: go to file
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact
        \ nmap <silent> gf <Plug>(coc-definition)
augroup END

endif

"## Plugin: fzf

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }

let g:fzf_command_prefix = 'Z'

if has('nvim') || has('popupwin')
  " fzf in popup window
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'BoxChar' } }
endif

" hide statusline while fzf-ing
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 nonumber norelativenumber noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 number relativenumber showmode ruler
endif

" better ripgrep command: ZRG
command! -nargs=* -bang ZRG call RipgrepFzf(<q-args>, <bang>0)
function! RipgrepFzf(query, fullscreen)
  let command_fmt = '[ -n %s ] && rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query), shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}', '{q}')
  let spec = {'options': ['--phony', '--prompt', 'Search > ', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

" keymaps: fzf
nmap <C-p>     :ZFiles<CR>
nmap <Leader>/ :ZLines<CR>
nmap <Leader>? :ZRG<CR>
nmap <Leader>b :ZBuffers<CR>
nmap <Leader>w :ZWindows<CR>

" keymaps: fzf-checkout
nmap <Leader>gc :ZGCheckout<CR>

"## Plugin: easy-align

" keymaps: easy-align
"" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"## Plugin: fugitive

" keymaps: fugitive
nmap <Leader>gs :G<CR>

"## Plugin: git-messenger

let g:git_messenger_no_default_mappings = v:true
let g:git_messenger_always_into_popup = v:true

" keymaps: git-messenger
nmap <Leader>go <Plug>(git-messenger)

function! s:setup_git_messenger_popup() abort
    nmap <buffer><Esc> <Plug>(git-messenger-close)
endfunction
autocmd FileType gitmessengerpopup call <SID>setup_git_messenger_popup()

"## Plugin: hexokinase

let g:Hexokinase_highlighters = ['foreground']

"## Plugin: markdown

let g:markdown_fenced_languages = ['css', 'help', 'html', 'javascript', 'js=javascript', 'json=javascript', 'lua', 'sh', 'typescript', 'ts=typescript', 'vim']

"## Plugin: maximizer

let g:maximizer_default_mapping_key = '<M-m>'

"## Plugin: startify

let g:startify_change_to_vcs_root = 1
let g:startify_custom_header = 'startify#center(startify#pad(startify#fortune#boxed()))'
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_session_sort = 1

let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

"## Plugin: tmux-navigator

let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-w>h     :TmuxNavigateLeft<CR>
nnoremap <silent> <C-w><C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-w>j     :TmuxNavigateDown<CR>
nnoremap <silent> <C-w><C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-w>k     :TmuxNavigateUp<CR>
nnoremap <silent> <C-w><C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-w>l     :TmuxNavigateRight<CR>
nnoremap <silent> <C-w><C-l> :TmuxNavigateRight<CR>
nnoremap <silent> <C-w>p     :TmuxNavigatePrevious<CR>
nnoremap <silent> <C-w><C-p> :TmuxNavigatePrevious<CR>

"## Plugin: tmux-resizer

let g:tmux_resizer_no_mappings = 1
let g:tmux_resizer_resize_count = 5
let g:tmux_resizer_vertical_resize_count = 10

nnoremap <silent> <C-w><M-h> :TmuxResizeLeft<CR>
nnoremap <silent> <C-w><M-j> :TmuxResizeDown<CR>
nnoremap <silent> <C-w><M-k> :TmuxResizeUp<CR>
nnoremap <silent> <C-w><M-l> :TmuxResizeRight<CR>

"## Plugin: vimspector

nmap <Leader>dc  <Plug>VimspectorContinue
nmap <Leader>ds  <Plug>VimspectorStop
nmap <Leader>dr  <Plug>VimspectorRestart
nmap <Leader>dp  <Plug>VimspectorPause
nmap <Leader>db  <Plug>VimspectorToggleBreakpoint
nmap <Leader>dcb <Plug>VimspectorToggleConditionalBreakpoint
nmap <Leader>dfb <Plug>VimspectorAddFunctionBreakpoint
nmap <Leader>dcc <Plug>VimspectorRunToCursor
nmap <Leader>dj  <Plug>VimspectorStepOver
nmap <Leader>dl  <Plug>VimspectorStepInto
nmap <Leader>dk  <Plug>VimspectorStepOut
nmap <Leader>dq  :VimspectorReset<CR>

"## neovim Plugins

if has('nvim')

lua << EOF

require('config/lsp')
require('config/telescope')
require('config/treesitter')
require('config/tree')

EOF

endif

"# Appearance Settings
set cursorline
set number relativenumber
set nowrap
set scrolloff=3

" always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

syntax enable

" enable truecolor
if has('termguicolors')
  if ! has('nvim')
    " *xterm-true-color*
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif

if !has('nvim')
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[2 q"
endif

augroup override_highlight
    autocmd!
    autocmd ColorScheme gruvbox highlight link BoxChar GruvboxGray
          \ | highlight link CocExplorerIndentLine BoxChar
augroup END

" theme
set background=dark

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
let g:gruvbox_invert_selection='0'
colorscheme gruvbox

"" airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
""" disable powerline arrows
let g:airline_left_sep=""
let g:airline_left_alt_sep=""
let g:airline_right_sep=""
let g:airline_right_alt_sep=""

" automatically toggle relative line number
augroup auto_relaivenumber_toggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &l:nu && empty(&bt) | setl rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &l:nu && empty(&bt) | setl nornu | endif
augroup END

" " keymaps: gruvbox
" if g:colors_name == 'gruvbox'
"   nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
"   nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
"   nnoremap <silent> yoh :call gruvbox#hls_toggle()<CR>
"   nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
"   nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
"   nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?
" endif

" fold settings
set foldlevelstart=15
set foldminlines=3

if has('nvim')
  autocmd Syntax css,go,html,javascript,javascriptreact,json,python,ruby,rust,toml,typescript,typescriptreact,yaml
   \ set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
else
  autocmd Syntax javascript,json,typescript setlocal foldmethod=syntax
endif

"### appearance: nvim-treesitter

if has('nvim')

" hi! link TSAnnotation
" hi! link TSAttribute
hi! link TSBoolean Boolean
hi! link TSCharacter Character
hi! link TSComment Comment
" hi! link TSConstructor
hi! link TSConditional Conditional
hi! link TSConstant Constant
hi! link TSConstBuiltin Constant
hi! link TSConstMacro Constant
" hi! link TSConstructor
hi! link TSError GruvboxRedUnderline
hi! link TSException Exception
" hi! link TSField
hi! link TSFloat Float
hi! link TSFunction Function
hi! link TSFuncBuiltin Function
" hi! link TSFuncMacro
hi! link TSInclude Include
hi! link TSKeyword GruvboxRed
hi! link TSKeywordFunction GruvboxAqua
hi! link TSKeywordOperator TSOperator
hi! link TSLabel Label
" hi! link TSMethod
" hi! link TSNamespace
" hi! link TSNone
hi! link TSNumber Number
" hi! link TSOperator
" hi! link TSParameter
" hi! link TSParameterReference
hi! link TSProperty GruvboxBlue
hi! link TSPunctBracket GruvboxFg1
hi! link TSPunctDelimiter GruvboxFg1
" hi! link TSPunctSpecial
hi! link TSRepeat Repeat
hi! link TSString String
" hi! link TSStringRegex
" hi! link TSStringEscape
" hi! link TSSymbol
hi! link TSTag GruvboxGreen
" hi! link TSTagDelimiter
" hi! link TSText
hi! TSStrong term=bold cterm=bold gui=bold
hi! TSEmphasis term=italic cterm=italic gui=italic
hi! TSUnderline term=underline cterm=underline gui=underline
hi! TSStrike term=strikethrough cterm=strikethrough gui=strikethrough
" hi! link TSTitle
" hi! link TSLiteral
" hi! link TSURI
" hi! link TSMath
" hi! link TSTextReference
" hi! link TSEnviroment
" hi! link TSEnviromentName
" hi! link TSNote
hi! link TSWarning WarningMsg
hi! link TSDanger ErrorMsg
hi! link TSType GruvboxAqua
hi! link TSTypeBuiltin Type
hi! link TSVariable GruvboxFg1
hi! link TSVariableBuiltin Identifier

endif

" Everything that can happen, happens. It has to end well and it has to end badly. It has to end every way it can.
