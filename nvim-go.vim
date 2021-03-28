let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  silent exec "!\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"
  autocmd VimEnter * PlugInstall
endif

call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'ratazzi/blackboard.vim'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'mhinz/vim-startify'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-lua/lsp-status.nvim'
Plug 'tpope/vim-commentary'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'  " to enable preview (optional)
Plug 'ojroques/nvim-lspfuzzy'
Plug 'datwaft/bubbly.nvim'
Plug 'sbdchd/neoformat'
Plug 'wfxr/minimap.vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
call plug#end()


" lua require('nvimlua') 
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/init.vim'

autocmd BufWritePre *.go lua goimports(100)


" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c

nnoremap <silent> ff    <cmd>lua vim.lsp.buf.formatting()<CR>

" Required:
filetype plugin indent on

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
"" Fix backspace indent
set backspace=indent,eol,start
"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab
"" Enable hidden buffers
set hidden
set path+=**
set wildmenu 
set wildignore+=**/node_modules/**

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set fileformats=unix,dos,mac
set mouse=a
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set shell=$SHELL
set nofoldenable

let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

"" Visual Settings
syntax on
set ruler
set number

silent! colorscheme blackboard
highlight Folded ctermbg=Gray ctermfg=Black

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10
set signcolumn=number
set clipboard=unnamed

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"Personal additions
"delete should not cut data. <leader>d can be used the way d was used previously
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d
:cmap Q q!

" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv
"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif
  return ''
endfunction


"" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>f :FZF -m<CR>
"Recovery commands from history through FZF
nmap <leader>y :History:<CR>

set statusline=
set statusline+=%{LspStatus()}

" startify 
autocmd VimEnter * if !argc()|  Startify |  NERDTree |  wincmd w | endif
let NERDTreeHijackNetrw = 0
