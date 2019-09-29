"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
let vimplug_exists=expand('~/.vim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"" Color
Plug 'tomasr/molokai'
" go
Plug 'govim/govim', { 'for': ['go'] }
" others
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" run :StripWhitespaces to strip whitespaces
Plug 'ntpeters/vim-better-whitespace'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
" Plug 'w0rp/ale'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-rhubarb' " required by fugitive to :Gbrowse
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'brooth/far.vim'
"
" html
Plug 'hail2u/vim-css3-syntax', { 'for': ['html', 'css','js'] }
Plug 'gorodinskiy/vim-coloresque', { 'for': ['html', 'css','js'] } " color preview
" javascript
Plug 'jelera/vim-javascript-syntax', { 'for': ['html', 'js'] }
" rust
Plug 'racer-rust/vim-racer', { 'for': ['rust'] }
Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
" Start page for vim
Plug 'mhinz/vim-startify'
" vimwiki
Plug 'vimwiki/vimwiki'
" buffer tabs
Plug 'ap/vim-buftabline'

Plug 'lifepillar/vim-mucomplete'

" Plug 'liuchengxu/vim-clap'
call plug#end()

"" Required:
filetype plugin indent on

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast
"" Fix backspace indent
set backspace=indent,eol,start
"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to ,
" let mapleader=','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

set fileformats=unix,dos,mac
set path+=**
set wildignore+=**/node_modules/**
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set mouse=a
set timeoutlen=1000 ttimeoutlen=0

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/zsh
endif

" use system clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif
"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number

let no_buffers_menu=1

set mousemodel=popup
set t_Co=256

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_faster = 1

if $TERM == 'xterm'
  set term=xterm-256color
endif
if &term =~ '256color'
  set t_ut=
endif

silent! colorscheme molokai
" transparent bg(use terminal bg color)
hi Normal guibg=NONE ctermbg=NONE



"" Disable the blinking cursor.
set gcr=a:blinkon0
" Disable visual bell and beeping
set noeb vb t_vb=
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

" set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ %=\ (%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)_

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv


"*****************************************************************************
"" Abbreviations
"*****************************************************************************
" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev Qa! qa!
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

com! FormatJSON %!python -m json.tool
com! J %!jq '.'

" set foldmethod=indent
set foldmethod=syntax
set foldnestmax=10
" set nofoldenable
" set foldlevel=2
set redrawtime=10000
" set regexpengine=1

set lazyredraw   " don't redraw everytime
set synmaxcol=128  " avoid slow rendering for long lines
syntax sync minlines=64  " faster syntax hl


" terminal emulation
nnoremap <silent> <leader>sh :terminal<CR>


"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

set autoread

" nerd tree with nerdtw

let g:netrw_banner=0        " disable annoying banner
let g:netrw_winsize = 18    " width in percent
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide = &wildignore
" let g:netrw_list_hide+=netrw_gitignore#Hide()
" " let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" " check: |netrw-browse-maps| for more mappings

function! ToggleNetrw()
        let i = bufnr("$")
        let wasOpen = 0
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
                let wasOpen = 1
            endif
            let i-=1
        endwhile
    if !wasOpen
        silent Lexplore
    endif
endfunction
map <F3> :call ToggleNetrw() <CR>


augroup ProjectDrawer
" startify
autocmd VimEnter *
            \  if !argc()
            \  |  Startify
            \  |  :call ToggleNetrw()
            \  |  wincmd w
            \  | endif
augroup END

let g:vimwiki_list = [{'path': '~/notes/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" Tabline controls
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
"" Close buffer
noremap <leader>c :bd<CR>
let g:buftabline_numbers=1
let g:buftabline_indicators=1

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>


"" fzf.vim
set wildmode=list:longest,list:full
" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif
" grep.vim
nnoremap <silent> <leader>f :Find<CR>


cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>e :FZF -m<CR>
"Recovery commands from history through FZF
nmap <leader>y :History:<CR>


" ale
" let g:ale_linters = {
" 	\ 'go': ['gopls'],
" 	\}
"
let g:polyglot_disabled = ['javascript', 'typescript', 'go']

" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" javascript
let g:javascript_enable_domhtmlcss = 1

" rust
" Vim racer
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

let g:rustfmt_autosave = 1
let g:rust_clip_command = 'xclip -selection clipboard'
let g:racer_experimental_completer = 1


let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }

augroup go
   au Filetype go  nmap <silent> <buffer> <Leader>h : <C-u>call GOVIMHover()<CR>
   au Filetype go  nmap <silent> <buffer> <F2> :execute "GOVIMQuickfixDiagnostics" | cw | if len(getqflist()) > 0 && getwininfo(win_getid())[0].quickfix == 1 | :wincmd p | endif<CR>
   au Filetype go  imap <silent> <buffer> <F2> <C-O>:execute "GOVIMQuickfixDiagnostics" | cw | if len(getqflist()) > 0 && getwininfo(win_getid())[0].quickfix == 1 | :wincmd p | endif<CR>
augroup END

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

augroup completion_preview_close
  autocmd!
  if v:version > 703 || v:version == 703 && has('patch598')
    autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
  endif
augroup END
set signcolumn=number

set completeopt+=menuone
set completeopt+=noselect
" set completeopt+=noinsert
set shortmess+=c   " Shut off completion messages
let g:mucomplete#enable_auto_at_startup = 1

" For vim clap
" nnoremap <C-C> <C-[>

augroup netrw_remap
    autocmd!
    autocmd filetype netrw call RemapNetRWToNerdTree()
augroup END
function! RemapNetRWToNerdTree()
    nmap <buffer> o <CR>
    nmap <buffer> <C-r> <C-l>
endfunction
